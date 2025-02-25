#!/bin/env zsh
SETTINGS="$( cd "$( dirname "${BASH_SOURCE[0]}" )/" >/dev/null 2>&1 && pwd )"
echo $SETTINGS
mkdir -p $HOME/bin/scripts
cp $SETTINGS/scripts/* $HOME/bin/scripts/ -r
echo 'export PATH="$HOME/bin/scripts:$PATH"' >> $ZDOTDIR/.zshrc
source $ZDOTDIR/.zshrc
git config --global alias.rebase-with-auto-tag rebase-with-auto-tag
exec zsh