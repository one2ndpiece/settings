default:
  just --list
args arg1="hehe":
  echo {{arg1}}
cd:
  pwd && cd check/to/path && pwd
gitcache:
  git config --global credential.helper 'cache --timeout=86400'