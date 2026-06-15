FROM ubuntu:24.04

ARG NIX_VERSION=latest

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Tokyo \
    USER=root

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        gnupg \
        dirmngr \
        tzdata \
        xz-utils \
    && ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo "${TZ}" > /etc/timezone \
    && rm -rf /var/lib/apt/lists/*

RUN if [[ "${NIX_VERSION}" == "latest" ]]; then \
      install_url="https://nixos.org/nix/install"; \
    else \
      install_url="https://releases.nixos.org/nix/nix-${NIX_VERSION}/install"; \
    fi \
    && curl --fail --location --silent --show-error "${install_url}" -o /tmp/install-nix \
    && sh /tmp/install-nix --daemon --yes --no-channel-add \
    && rm -f /tmp/install-nix

RUN printf '%s\n' \
      "experimental-features = nix-command flakes" \
      "sandbox = false" \
      >> /etc/nix/nix.conf

ENV PATH="/nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin:${PATH}"

RUN nix --version \
    && nix store info --store local

LABEL org.opencontainers.image.source="https://github.com/one2ndpiece/settings" \
      org.opencontainers.image.description="Ubuntu 24.04 Dev Container base with Nix"
