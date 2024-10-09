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
    git config --global user.name "dummy" &&\
    git config --global --add safe.directory /workspace/nextcloud
# -----------------------------------------------------
RUN echo "export LANG=ja_JP.UTF-8" >> ~/.bashrc &&\
    source ~/.bashrc
# -----------------------------------------------------

RUN apt update && apt install gh
# -----------------------------------------------------
# Git ブランチ名をプロンプトに表示する設定を追加
RUN echo 'parse_git_branch() { git branch --show-current 2>/dev/null; }' >> ~/.bashrc && \
    echo 'PS1="(\$(parse_git_branch)) \u@\h:\w\$ "' >> ~/.bashrc && \
    source ~/.bashrc