# neovim
git clone --depth 1 https://github.com/wbthomason/packer.nvim \
    ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# `init.lua` をコピー
mkdir -p ~/.config/nvim
cp -r ~/settings/dotfiles/.config/nvim/init.lua ~/.config/nvim/init.lua

# viモードにする
set -o vi

# 環境変数を設定
echo "export EDITOR=nvim" >> ~/.bashrc
echo "export VISUAL=nvim" >> ~/.bashrc
. ~/.bashrc

# パッケージをインストール
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

# プロジェクトのディレクトリにファイルをコピー
cat ~/settings/dotfiles/.bashrc_additions >> ~/.bashrc && . ~/.bashrc
cat ~/settings/dotfiles/.inputrc >> ~/.inputrc && bind -f ~/.inputrc
cat ~/settings/dotfiles/.tmux.conf >> ~/.tmux.conf && tmux source-file ~/.tmux.conf