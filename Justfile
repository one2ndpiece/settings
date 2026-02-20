set dotenv-load

mod sample 'scripts/justfile/sample.just'
mod aws 'scripts/justfile/aws.just'
# list
default:
  just --list

[arg("email",long="email",short="e")]
[arg("name",long="name",short="n")]
init email="$EMAIL" name="$NAME":
  git config --global user.email {{email}}
  git config --global user.name {{name}}
  @echo "=== Git Configuration ==="
  @git config --global user.email
  @git config --global user.name
# boxをマウント(wslで実行)
box-mount:
  sudo mount -t drvfs 'C:\Users\戸波勇人\Box' /mnt/box
# mermaid-live-editorを起動
mermaid-live-editor:
  docker run --platform linux/amd64 --publish 8000:8080 --rm --pull always ghcr.io/mermaid-js/mermaid-live-editor
