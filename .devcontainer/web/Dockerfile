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
RUN git config --global user.email "tonami.yuto@unkman.jp" &&\
    git config --global user.name "YutoTonami" 

# -----------------------------------------------------
RUN echo "export LANG=ja_JP.UTF-8" >> ~/.bashrc &&\
    source ~/.bashrc
# -----------------------------------------------------
# # pyenvのインストール
# RUN export DEBIAN_FRONTEND=noninteractive &&\
#     apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python3-openssl git &&\
#     curl https://pyenv.run | bash &&\
#     export PATH="$HOME/.pyenv/bin:$PATH" &&\
#     eval "$(pyenv init --path)" &&\
#     eval "$(pyenv init -)" &&\
#     eval "$(pyenv virtualenv-init -)" &&\
#     pyenv install 3.9.13 &&\
#     pyenv install 3.11.4 &&\
#     pyenv global 3.9.13
# -----------------------------------------------------
# # pyenvとlangを.bashrcに記載するだけ。
# RUN echo "export PATH=\"$HOME/.pyenv/bin:\$PATH\"" >> ~/.bashrc &&\
#     echo 'eval "$(pyenv init --path)"' >> ~/.bashrc &&\
#     echo 'eval "$(pyenv init -)"' >> ~/.bashrc &&\
#     echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc &&\
#     source ~/.bashrc
# -----------------------------------------------------
# nvmからnpmをインストール
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash &&\
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")" &&\
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" &&\
    nvm install node &&\
    nvm use node 
#     npm install -g cdk
