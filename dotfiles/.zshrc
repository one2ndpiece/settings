# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# 一時ファイルを作成する
# オプション -e で最後に作成したファイルを実行する
scf() {
    # スクリプト保存ディレクトリを定義
    local script_dir="/tmp/temp_script"
    local last_script_path="${script_dir}/last_script_path.txt"

    # ディレクトリが存在しなければ作成
    mkdir -p "$script_dir"

    case "$1" in
        -e)  # 実行モード：最後に作成されたスクリプトを実行
            if [[ -f "$last_script_path" ]]; then
                last_script=$(cat "$last_script_path")
                echo "last_script: $last_script"
                echo -e "\n----------------------------------------\n"
                cat "$last_script"
                echo -e "\n----------------------------------------\n"
                if [[ -f "$last_script" ]]; then
                    echo -n "Do you want to run the last created script? (y/n): "
                    read confirm
                    if [[ "$confirm" == "y" ]]; then
                        echo "Running the last created script..."
                        "$last_script"
                    else
                        echo "Execution cancelled."
                    fi
                else
                    echo "No script found. Please create a new script first."
                fi
            else
                echo "No script record found. Please create a new script first."
            fi
            ;;

        -c)  # 確認モード：最後に作成されたスクリプトを表示
            if [[ -f "$last_script_path" ]]; then
                last_script=$(cat "$last_script_path")
                echo "last_script: $last_script"
                echo -e "\n----------------------------------------\n"
                cat "$last_script"
                echo -e "\n----------------------------------------\n"
            else
                echo "No script record found. Please create a new script first."
            fi
            ;;
        -n)  # 新しいスクリプトを作成
            # タイムスタンプで一意のファイル名を作成
            local timestamp=$(date +"%Y%m%d_%H%M%S")
            local tmpfile="${script_dir}/tmp_script_${timestamp}.sh"

            touch "$tmpfile"  # ファイルを作成
            chmod +x "$tmpfile"

            # cursorで開き、失敗した場合はcodeを使う
            if ! cursor "$tmpfile" 2>/dev/null; then
                echo "cursor not available, opening with VS Code..."
                if ! code "$tmpfile"; then
                    echo -e "editor not available, exiting...\n"
                    echo -e "Please use another editor.\n"
                    echo -e "\nscript file has been made at: $tmpfile\n"
                    echo -e "command 'scf -e' is available.\n"
                    return 1
                fi
            fi
            echo "Temporary file created and saved at: $tmpfile"
            echo "execute: scf -e"
            # 更新された一時ファイルのパスを記録
            echo "$tmpfile" > "$last_script_path"
            ;;
        -h|--help|*)  # ヘルプ表示または無効なオプション
            echo "Usage: scf [options]"
            echo "Options:"
            echo "  -n            Create a new script"
            echo "  -e            Execute the last created script"
            echo "  -h, --help    Display this help message"
            echo "  -c            Confirm the last created script"
            ;;
    esac
}

# aicommit2 のエイリアス
alias aic='aicommit2 --locale 'jp' --generate 3'

# PROMPT_SUBST を有効にして、PROMPT 内のコマンド置換を毎回実行する
setopt PROMPT_SUBST
# 1. カスタム1段目のための関数群

# 仮想環境のPythonバージョン表示関数
virtualenv_prompt() {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        local venv_name
        venv_name=$(basename "$VIRTUAL_ENV")
        local py_version
        py_version=$("$VIRTUAL_ENV/bin/python" --version 2>&1 | awk '{print $2}')
        echo "($venv_name:$py_version)"
    fi
}

# 1段目の文字列を作成する関数
# 左側：仮想環境情報（存在する場合）とカレントディレクトリの絶対パス（$PWD）
# 右側：現在日時。左右の間はハイフンで埋める。
_1st_line() {
    local venv=$(virtualenv_prompt)
    local left_text="${venv}$PWD#"
    # TZ=JST-9 を使用して JST（UTC+9）で日時を取得
    local right_text="[$(TZ=JST-9 date '+%Y-%m-%d %H:%M:%S')]"
    local WIDTH=$(tput cols)
    local left_len=${#left_text}
    local right_len=${#right_text}
    local middle_len=$(( WIDTH - left_len - right_len - 1 ))
    (( middle_len < 0 )) && middle_len=0
    printf "%s" "$left_text"
    printf "%${middle_len}s" "" | tr ' ' '-'
    echo " $right_text"
}



# precmd フック用の関数（プロンプト表示前に1段目を出力）
_print_first_line() {
    echo "$(_1st_line)"
}

# precmd_functions 配列に追加して、毎回プロンプト前に実行させる
precmd_functions+=( _print_first_line )


# 2. 2段目は oh‑my‑zsh のデフォルト設定に任せるため、
# ここでは PROMPT の設定は行わず、テーマ（例: robbyrussell など）が定義する内容がそのまま利用されます。


#---------------------------------------------
# 履歴をファイルに追記する（セッション終了時に上書きせず、既存の履歴に加える）
setopt append_history

# コマンド実行ごとに即座に履歴ファイルに書き込む
setopt inc_append_history

# 履歴を複数のセッション間で共有する
setopt share_history

setopt hist_ignore_all_dups

#---------------------------------------------
# AWS CLI の補完を有効にする（aws_completer のパスは環境に合わせて変更）
complete -C '/usr/local/bin/aws_completer' aws

export VIRTUAL_ENV_DISABLE_PROMPT=1
