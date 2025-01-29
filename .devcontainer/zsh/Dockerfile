# Dockerfile
FROM ubuntu:22.04

RUN apt update && apt install -y zsh

SHELL ["/bin/zsh", "-c"]
# 必要なパッケージのインストールや設定をここに追加
RUN apt update
RUN apt install -y less language-pack-ja-base language-pack-ja zip curl jq groff tmux git neovim

# workspaceディレクトリを作成して権限を設定
RUN mkdir -p workspace/ && chmod -R +x workspace/
# -----------------------------------------------------
# gitの設定
RUN git config --global user.email "dummy@dummy.com" &&\
    git config --global user.name "YutoTonami" &&\
    git config --global core.quotepath false

# -----------------------------------------------------
RUN curl -LsSf https://astral.sh/uv/install.sh | sh &&\
    source ~/.zshrc
# -----------------------------------------------------
# nvmからnpmをインストール
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash &&\
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")" &&\
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" &&\
    nvm install node &&\
    nvm use node &&\
    npm install -g cdk &&\
    npm install -g aicommit2

