FROM ubuntu
ARG S6_OVERLAY_VERSION=3.1.5.0

RUN apt-get update && apt-get install -y xz-utils curl fuse

# install S6
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz

COPY s6 /etc/s6-overlay/s6-rc.d

ADD https://nixos.org/nix/install /tmp/nix-install
RUN chmod 666 /tmp/nix-install
RUN useradd --create-home sandbox
RUN groupadd nixbld
RUN usermod -a -G nixbld sandbox
RUN mkdir -m 0755 /nix /mnt/restic && chown -R sandbox /nix /etc/s6-overlay /mnt/restic

USER sandbox

RUN sh /tmp/nix-install --no-daemon
RUN PATH=$HOME/.nix-profile/bin:$PATH \
 && nix-env -i filebrowser restic \
 && nix-env --delete-generations old \
 && nix-store --gc

ENTRYPOINT ["/init"]
