#!/bin/bash
DOTFILES="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../" >/dev/null 2>&1 && pwd )"
#---------------------------------------------
ln -sf $DOTFILES/.zshenv $HOME/.zshenv && . $HOME/.zshenv
#---------------------------------------------
# oh-my-zshのインストール
if [ -d "$ZSH" ]; then
  echo "Oh My Zsh is already installed at $ZSH. Skipping installation."
else
  echo n| sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
#---------------------------------------------
touch $DOTFILES/.config/zsh/custom.zsh
#---------------------------------------------
mkdir -p $HOME/.config/zsh
for file in $DOTFILES/.config/zsh/{*,.[!.]*}; do
  ln -sf "$file" "$HOME/.config/zsh"
done