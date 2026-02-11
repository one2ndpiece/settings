set dotenv-load

mod sample 'scripts/justfile/sample.just'
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
