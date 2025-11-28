#!/bin/bash
DOTFILES="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../" >/dev/null 2>&1 && pwd )"

#---------------------------------------------
ln -sf $DOTFILES/.config/tmux/.tmux.conf $HOME/.tmux.conf

