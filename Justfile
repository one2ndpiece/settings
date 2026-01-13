mod script 'scripts/justfile/sample.just'
# list
default:
  just --list
gitsetup:
  git config --global credential.helper 'cache --timeout=86400'