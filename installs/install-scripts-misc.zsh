#!/bin/env zsh
SETTINGS=$( cd "$( dirname "${(%):-%N}" )/../" >/dev/null 2>&1 && pwd )
echo "SETTINGS: $SETTINGS"

SCRIPTS_DIR=$SETTINGS/scripts/misc

echo 'export PATH="'$SCRIPTS_DIR':$PATH"' >> $ZDOTDIR/custom.zsh
# スクリプトに実行権限を付与
chmod +x $SCRIPTS_DIR/* -R

exec zsh