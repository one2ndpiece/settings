#!/bin/env zsh
# このスクリプトは、自身の設定ディレクトリを基準にスクリプトをコピーし、
# $HOME/bin/scripts をPATHに追加した上で、git-で始まるスクリプトから自動でaliasを作成します。

# 1. 設定ディレクトリの取得
SETTINGS=$( cd "$( dirname "${(%):-%N}" )/../" >/dev/null 2>&1 && pwd )
echo "SETTINGS: $SETTINGS"

# 2. スクリプトディレクトリの作成とファイルのコピー
mkdir -p $HOME/bin/scripts
cp -r $SETTINGS/scripts/* $HOME/bin/scripts/

# 3. PATHにスクリプトディレクトリを追加する設定を.zshrcに追記し、即時反映
echo 'export PATH="$HOME/bin/scripts:$PATH"' >> $ZDOTDIR/custom.zsh
source $ZDOTDIR/.zshrc

# 4. $HOME/bin/scripts内の「git-」で始まるファイルからaliasを自動生成
for script in $HOME/bin/scripts/git-*; do
  # ファイルかどうかのチェック（ディレクトリは除外）
  if [[ -f "$script" ]]; then
    base=$(basename "$script")
    # "git-"の部分を除いた文字列をalias名として取得
    alias_name=${base#git-}
    # gitのaliasとして設定（例: git config --global alias.foo foo）
    git config --global alias.$alias_name $alias_name
    echo "Alias 作成: git $alias_name -> $alias_name"
  fi
done

chmod +x $HOME/bin/scripts/* -R

# 5. 新しいシェルに入る
exec zsh
