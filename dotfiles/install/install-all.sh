#!/bin/bash
DOTFILES="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../" >/dev/null 2>&1 && pwd )"

#---------------------------------------------
# インストール
#---------------------------------------------
$DOTFILES/install/install-zsh.sh
$DOTFILES/install/install-tmux.sh
