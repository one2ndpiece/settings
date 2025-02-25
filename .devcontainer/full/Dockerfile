# Dockerfile
FROM ubuntu:22.04
SHELL ["/bin/bash", "-c"]
COPY dotfiles/.bashrc ~/.bashrc
# 必要なパッケージのインストールや設定をここに追加
RUN apt update && apt install -y less language-pack-ja-base language-pack-ja zip curl jq groff git tmux gh neovim

# workspaceディレクトリを作成して権限を設定
RUN mkdir -p workspace/ && chmod -R +x workspace/
# -----------------------------------------------------
# gitの設定
RUN git config --global user.email "dummy@dummy.com" &&\
    git config --global user.name "dummy" &&\
    git config --global core.quotepath false

# -----------------------------------------------------
RUN LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*') &&\
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" &&\
    tar xf lazygit.tar.gz lazygit &&\
    install lazygit -D -t /usr/local/bin/
# -----------------------------------------------------

RUN curl -LsSf https://astral.sh/uv/install.sh | sh &&\
    source ~/.bashrc
# -----------------------------------------------------
# nvmからnpmをインストール
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash &&\
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")" &&\
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" &&\
    nvm install node &&\
    nvm use node &&\
    npm install -g cdk
