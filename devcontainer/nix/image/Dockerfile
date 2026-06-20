FROM ubuntu:24.04

ARG TARGETARCH
# stable resolves to the latest non-prerelease GitHub release at build time.
ARG JUST_VERSION=stable
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
        locales \
        tzdata \
        xz-utils \
    && ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo "${TZ}" > /etc/timezone \
    && sed -i 's/^# *\(ja_JP.UTF-8 UTF-8\)/\1/' /etc/locale.gen \
    && locale-gen ja_JP.UTF-8 \
    && update-locale LANG=ja_JP.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

RUN case "${TARGETARCH:-$(dpkg --print-architecture)}" in \
      amd64) just_target="x86_64-unknown-linux-musl" ;; \
      arm64) just_target="aarch64-unknown-linux-musl" ;; \
      *) echo "Unsupported architecture: ${TARGETARCH:-$(dpkg --print-architecture)}" >&2; exit 1 ;; \
    esac \
    && just_version="${JUST_VERSION}" \
    && if [[ "${just_version}" == "stable" || "${just_version}" == "latest" ]]; then \
      just_version="$(curl --fail --location --silent --show-error https://api.github.com/repos/casey/just/releases/latest \
        | sed -n "s/.*\"tag_name\": *\"\([^\"]*\)\".*/\1/p" \
        | head -n 1)"; \
    fi \
    && if [[ ! "${just_version}" =~ ^[0-9]+[.][0-9]+[.][0-9]+$ ]]; then \
      echo "Could not resolve a stable just release: ${just_version}" >&2; \
      exit 1; \
    fi \
    && just_archive="just-${just_version}-${just_target}.tar.gz" \
    && just_url="https://github.com/casey/just/releases/download/${just_version}" \
    && curl --fail --location --silent --show-error "${just_url}/${just_archive}" -o "/tmp/${just_archive}" \
    && curl --fail --location --silent --show-error "${just_url}/SHA256SUMS" -o /tmp/just-SHA256SUMS \
    && cd /tmp \
    && grep -F "  ${just_archive}" just-SHA256SUMS | sha256sum --check --strict - \
    && tar -xzf "${just_archive}" just \
    && install -m 0755 just /usr/local/bin/just \
    && rm -f just "${just_archive}" just-SHA256SUMS \
    && just --version

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

ENV LANG=ja_JP.UTF-8 \
    PATH="/nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin:${PATH}"

RUN nix --version \
    && nix store info --store local \
    && just --version

LABEL org.opencontainers.image.source="https://github.com/one2ndpiece/settings" \
      org.opencontainers.image.description="Ubuntu 24.04 Dev Container base with just and Nix"
