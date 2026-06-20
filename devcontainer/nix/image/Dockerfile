FROM ubuntu:24.04

ARG TARGETARCH
ARG JUST_VERSION=1.53.0
ARG JUST_SHA256_AMD64=7fedeb22c7e14d9ef1551e8b793700866d80f409f9884b0e80ebb65c11d4874d
ARG JUST_SHA256_ARM64=f29d8e72380bc144465f632c7d59da311205eef2923d57511708b05b82f2e64f
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
      amd64) just_target="x86_64-unknown-linux-musl"; just_sha256="${JUST_SHA256_AMD64}" ;; \
      arm64) just_target="aarch64-unknown-linux-musl"; just_sha256="${JUST_SHA256_ARM64}" ;; \
      *) echo "Unsupported architecture: ${TARGETARCH:-$(dpkg --print-architecture)}" >&2; exit 1 ;; \
    esac \
    && just_archive="just-${JUST_VERSION}-${just_target}.tar.gz" \
    && just_url="https://github.com/casey/just/releases/download/${JUST_VERSION}" \
    && curl --fail --location --silent --show-error "${just_url}/${just_archive}" -o "/tmp/${just_archive}" \
    && printf '%s  %s\n' "${just_sha256}" "/tmp/${just_archive}" | sha256sum --check --strict - \
    && cd /tmp \
    && tar -xzf "${just_archive}" just \
    && install -m 0755 just /usr/local/bin/just \
    && rm -f just "${just_archive}" \
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
