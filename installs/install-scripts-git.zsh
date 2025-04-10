#!/bin/env zsh
# このスクリプトは、自身の設定ディレクトリのscriptsをPATHに追加し、
# git-で始まるスクリプトから自動でaliasを作成します。

# 1. 設定ディレクトリの取得
SETTINGS=$( cd "$( dirname "${(%):-%N}" )/../" >/dev/null 2>&1 && pwd )
echo "SETTINGS: $SETTINGS"

# スクリプトディレクトリの定義
SCRIPTS_DIR=$SETTINGS/scripts/git

# 2. PATHにスクリプトディレクトリを追加する設定を.zshrcに追記し、即時反映
echo 'export PATH="'$SCRIPTS_DIR':$PATH"' >> $ZDOTDIR/custom.zsh
source $ZDOTDIR/.zshrc

# 3. スクリプトディレクトリ内の「git-」で始まるファイルからaliasを自動生成
for script in $SCRIPTS_DIR/git-*; do
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

# スクリプトに実行権限を付与
chmod +x $SCRIPTS_DIR/* -R

# 4. 新しいシェルに入る
exec zsh
