# Dockerfile
FROM ubuntu:22.04
# デフォルトのシェルをbashに設定
SHELL ["/bin/bash", "-c"]
# 必要なパッケージのインストールや設定をここに追加
RUN apt-get update && apt-get install -y less language-pack-ja-base language-pack-ja zip curl jq
# workspaceディレクトリを作成して権限を設定
RUN mkdir -p workspace/ && chmod -R +x workspace/
# -----------------------------------------------------
RUN apt-get install -y git
# gitの設定
RUN git config --global user.email "dummy@dummy.com" &&\
    git config --global user.name "dummy"

# -----------------------------------------------------
RUN echo "export LANG=ja_JP.UTF-8" >> ~/.bashrc &&\
    source ~/.bashrc
# nvmからnpmをインストール
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash &&\
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")" &&\
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" &&\
    nvm install node &&\
    nvm use node &&\
    npm install -g gh@latest
