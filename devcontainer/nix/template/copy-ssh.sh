#!/usr/bin/env bash
set -euo pipefail

source_dir="/opt/.ssh"
target_dir="${HOME}/.ssh"

if [[ ! -d "${source_dir}" ]]; then
  exit 0
fi

mkdir -p "${target_dir}"
cp -R "${source_dir}/." "${target_dir}/"

chown -R "$(id -u):$(id -g)" "${target_dir}"
find "${target_dir}" -type d -exec chmod 700 {} +
find "${target_dir}" -type f -exec chmod 600 {} +
find "${target_dir}" -type f -name "*.pub" -exec chmod 644 {} +
