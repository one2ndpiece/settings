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

