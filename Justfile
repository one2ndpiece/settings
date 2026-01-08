default:
  just --list
args arg1="hello":
  echo {{arg1}}
  echo "asdf\
  asdfa\
  asdf\
  "
cd:
  pwd && cd .devcontainer && ls -la
  pwd && ls -la
gitsetup:
  git config --global credential.helper 'cache --timeout=86400'