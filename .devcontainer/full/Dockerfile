# Dockerfile
FROM ubuntu:22.04
SHELL ["/bin/bash", "-c"]
# 必要なパッケージのインストールや設定をここに追加
RUN apt update && apt install -y less language-pack-ja-base language-pack-ja zip curl jq groff git tmux entr tree lsof build-essential iproute2

# workspaceディレクトリを作成して権限を設定
RUN mkdir -p workspace/ && chmod -R +x workspace/
# -----------------------------------------------------
# gitの設定
RUN git config --global user.email "dummy@dummy.com" &&\
    git config --global user.name "dummy" &&\
    git config --global core.quotepath false &&\
    git lfs install
# -----------------------------------------------------
# 日本時間の設定
RUN apt-get update &&\
    DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata &&\
    ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
# -----------------------------------------------------
# rustのインストール
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
# -----------------------------------------------------
RUN git clone https://github.com/one2ndpiece/settings.git /opt/settings &&\
    /opt/settings/dotfiles/install/install-all.sh
