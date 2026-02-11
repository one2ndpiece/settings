#!/bin/bash
set -e

# 個人的な設定のインストール
git clone https://github.com/one2ndpiece/settings.git /opt/settings
/opt/settings/dotfiles/install/install-all.sh
