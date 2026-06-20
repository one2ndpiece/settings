set dotenv-load

mod sample 'scripts/justfile/sample.just'
mod aws 'scripts/justfile/aws.just'
mod misc 'scripts/justfile/misc.just'
# list
default:
  just --list

# flake.lockを作成・更新
flake-lock:
  nix flake lock

# Home Managerプロファイルを有効化
home-activate:
  @if [ ! -f flake.lock ]; then \
    nix flake lock; \
  fi
  nix run --no-write-lock-file path:$PWD#home-activate

[arg("email",long="email",short="e")]
[arg("name",long="name",short="n")]
init email="$EMAIL" name="$NAME":
  git config --global user.email {{email}}
  git config --global user.name {{name}}
  @echo "=== Git Configuration ==="
  @git config --global user.email
  @git config --global user.name
  @git config --global --add safe.directory /workspace/settings
# boxをマウント(wslで実行)
box-mount:
  sudo mount -t drvfs 'HOST_BOX_DIR' /mnt/box
# mermaid-live-editorを起動
mermaid-live-editor:
  docker run --platform linux/amd64 --publish 8000:8080 --rm --pull always ghcr.io/mermaid-js/mermaid-live-editor
# copy mounted host SSH files into the devcontainer root home
copy-ssh source_dir="/opt/.ssh" target_dir="/root/.ssh":
  @if [ ! -d "{{source_dir}}" ]; then \
    echo "SSH source directory was not mounted: {{source_dir}}" >&2; \
    exit 0; \
  fi
  mkdir -p "{{target_dir}}"
  cp -R "{{source_dir}}/." "{{target_dir}}/"
  chown -R "$(id -u):$(id -g)" "{{target_dir}}"
  find "{{target_dir}}" -type d -exec chmod 700 {} +
  find "{{target_dir}}" -type f -exec chmod 600 {} +
  find "{{target_dir}}" -type f -name "*.pub" -exec chmod 644 {} +
  @echo "SSH files copied to {{target_dir}}"