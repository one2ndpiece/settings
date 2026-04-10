export ZSH="$ZDOTDIR/ohmyzsh"

ZSH_THEME="robbyrussell"

plugins=(git aws)

source $ZSH/oh-my-zsh.sh

#---------------------------------------------
# aicommit2 のエイリアス
alias aic='aicommit2 --locale 'jp' --generate 3'

#---------------------------------------------
# プロンプトの設定
source "$HOME/.config/zsh/prompt.zsh"
#---------------------------------------------
source "$HOME/.config/zsh/scripts.zsh"
#---------------------------------------------
source "$HOME/.config/zsh/custom.zsh"
#---------------------------------------------
# 履歴をファイルに追記する（セッション終了時に上書きせず、既存の履歴に加える）
setopt append_history

# コマンド実行ごとに即座に履歴ファイルに書き込む
setopt inc_append_history

# 履歴を複数のセッション間で共有する
setopt share_history

setopt hist_ignore_all_dups
#---------------------------------------------
# 日本語
export LANG=ja_JP.UTF-8
export LC_ALL=ja_JP.UTF-8

autoload -Uz +X bashcompinit && bashcompinit
if [ -f "/etc/bash_completion.d/azure-cli" ]; then
    source /etc/bash_completion.d/azure-cli
fi
#---------------------------------------------
# aws-vault の設定
export AWS_VAULT_BACKEND=file
#---------------------------------------------
# VS Code terminal では IPC ソケットの場所が環境によって異なる
typeset -a _vscode_ipc_candidates
_vscode_ipc_candidates=(
    /run/user/$(id -u)/vscode-ipc-*.sock(Nom[1])
    /tmp/user/$(id -u)/vscode-ipc-*.sock(Nom[1])
)
if [[ -n "${_vscode_ipc_candidates[1]}" ]]; then
    export VSCODE_IPC_HOOK_CLI="${_vscode_ipc_candidates[1]}"
fi
unset _vscode_ipc_candidates
#----------------ここまでがclone----------------
