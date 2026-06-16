#!/usr/bin/env bash
set -euo pipefail

if [[ "$(id -u)" -ne 0 ]]; then
  echo "The image must run as root." >&2
  exit 1
fi

nix --version
nix store info --store local
locale -a | grep -qx "ja_JP.utf8"
LANG=ja_JP.UTF-8 LC_ALL=ja_JP.UTF-8 locale >/dev/null

flake_dir="$(mktemp --directory)"
trap 'rm -rf "${flake_dir}"' EXIT
cat >"${flake_dir}/flake.nix" <<'EOF'
{
  outputs = { self }: {
    smoke = "ok";
  };
}
EOF
nix flake metadata --no-write-lock-file "path:${flake_dir}"
test "$(nix eval --raw "path:${flake_dir}#smoke")" = "ok"

cp --dereference /etc/os-release /tmp/os-release
store_path="$(nix-store --add-fixed sha256 /tmp/os-release)"
test -e "${store_path}"
