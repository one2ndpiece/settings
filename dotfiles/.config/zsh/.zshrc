export ZSH="$ZDOTDIR/ohmyzsh"

ZSH_THEME="robbyrussell"

plugins=(git)

if [[ -f "$HOME/.config/zsh/modules/aws.before.zsh" ]]; then
    source "$HOME/.config/zsh/modules/aws.before.zsh"
fi

if [[ -f "$ZSH/oh-my-zsh.sh" ]]; then
    source "$ZSH/oh-my-zsh.sh"
fi

#---------------------------------------------
# プロンプトの設定
source "$HOME/.config/zsh/prompt.zsh"
#---------------------------------------------
if [[ -f "$HOME/.config/zsh/modules/azure.zsh" ]]; then
    source "$HOME/.config/zsh/modules/azure.zsh"
fi
#---------------------------------------------
if command -v direnv >/dev/null 2>&1; then
    eval "$(direnv hook zsh)"
fi
#---------------------------------------------
if [[ -f "$HOME/.config/zsh/custom.zsh" ]]; then
    source "$HOME/.config/zsh/custom.zsh"
fi
#---------------------------------------------
# 履歴をファイルに追記する（セッション終了時に上書きせず、既存の履歴に加える）
setopt append_history

# コマンド実行ごとに即座に履歴ファイルに書き込む
setopt inc_append_history

# 履歴を複数のセッション間で共有する
setopt share_history

setopt hist_ignore_all_dups

export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
mkdir -p "$XDG_STATE_HOME/zsh"
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=10000
SAVEHIST=10000
#---------------------------------------------
# 日本語
export LANG=ja_JP.UTF-8
export LC_ALL=ja_JP.UTF-8
