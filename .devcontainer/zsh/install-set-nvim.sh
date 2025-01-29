# neovim
git clone --depth 1 https://github.com/wbthomason/packer.nvim \
    ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# `init.lua` をコピー
mkdir -p ~/.config/nvim
cp -r ~/settings/dotfiles/.config/nvim/init.lua ~/.config/nvim/init.lua

# viモードにする
echo "set -o vi" >> ~/.zshrc

# 環境変数を設定
echo "export EDITOR=nvim" >> ~/.zshrc
echo "export VISUAL=nvim" >> ~/.zshrc
. ~/.zshrc

# パッケージをインストール
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

# プロジェクトのディレクトリにファイルをコピー
cat ~/settings/dotfiles/.zshrc_additions >> ~/.zshrc && . ~/.zshrc
cat ~/settings/dotfiles/.inputrc >> ~/.inputrc && bind -f ~/.inputrc
cat ~/settings/dotfiles/.tmux.conf >> ~/.tmux.conf && tmux source-file ~/.tmux.conf
