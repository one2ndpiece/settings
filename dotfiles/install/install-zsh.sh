#!/bin/bash
DOTFILES="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../" >/dev/null 2>&1 && pwd )"

#---------------------------------------------
# zshのインストール
apt update && apt install -y zsh
#---------------------------------------------
ln -sf $DOTFILES/.config/zsh/.zshenv $HOME/.zshenv && . $HOME/.zshenv
#---------------------------------------------
# oh-my-zshのインストール
echo n| sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
#---------------------------------------------
mkdir -p $HOME/.config/zsh
for file in $DOTFILES/.config/zsh/{*,.[!.]*}; do
  ln -sf "$file" "$HOME/.config/zsh"
done