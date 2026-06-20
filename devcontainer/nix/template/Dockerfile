FROM ghcr.io/one2ndpiece/nix-devcontainer:ubuntu-24.04

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

WORKDIR /opt/devcontainer

COPY flake.nix flake.lock ./

RUN just --version \
    && nix flake check --all-systems \
    && nix run .#home-activate \
    && mkdir -p /root/.config/zsh \
    && touch /root/.config/zsh/custom.zsh \
    && nix-collect-garbage --delete-old \
    && test -x /root/.nix-profile/bin/zsh \
    && { \
      grep -qxF /root/.nix-profile/bin/zsh /etc/shells \
      || echo /root/.nix-profile/bin/zsh >> /etc/shells; \
    } \
    && usermod --shell /root/.nix-profile/bin/zsh root \
    && test "$(PATH="/root/.nix-profile/bin:${PATH}" command -v just)" = /usr/local/bin/just

ENV PATH="/root/.nix-profile/bin:/nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin:${PATH}" \
    SHELL="/root/.nix-profile/bin/zsh"
