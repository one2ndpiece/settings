# Dockerfile
FROM ubuntu:22.04
SHELL ["/bin/bash", "-c"]
# 必要なパッケージのインストールや設定をここに追加
RUN apt update && apt install -y less language-pack-ja-base language-pack-ja zip curl jq groff git gh

# workspaceディレクトリを作成して権限を設定
RUN mkdir -p workspace/ && chmod -R +x workspace/
# -----------------------------------------------------
# gitの設定
RUN git config --global user.email "dummy@dummy.com" &&\
    git config --global user.name "dummy" &&\
    git config --global core.quotepath false
