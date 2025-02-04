# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
#if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
#    . /etc/bash_completion
#fi

. "$HOME/.local/bin/env"
#######################################################
# .bashrc_additions
#######################################################
export LANG=ja_JP.UTF-8

# aicommit2 のエイリアス
alias aic='aicommit2 --locale 'jp' --generate 3'

# Gitブランチ表示関数
parse_git_branch() {
    if [[ -d .git ]]; then
        local branch=$(git branch --show-current 2>/dev/null)
        [[ -n "$branch" ]] && echo "($branch)"
    fi
}

# 仮想環境のPythonバージョン表示関数
virtualenv_prompt() {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        local venv_name=$(basename "$VIRTUAL_ENV")
        local py_version=$("$VIRTUAL_ENV/bin/python" --version 2>&1 | awk '{print $2}')
        echo "($venv_name:$py_version)"
    fi
}

#　上書き
export PROMPT_COMMAND='PS1="$(virtualenv_prompt)\$(parse_git_branch)\u@\h:\w\$ "'


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
                    read -p "Do you want to run the last created script? (y/n): " confirm
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

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
#######################################################
# .bashrc_additions
#######################################################

# aicommit2 のエイリアス
alias aic='aicommit2 --locale 'jp' --generate 3'

# Gitブランチ表示関数
parse_git_branch() {
    if [[ -d .git ]]; then
        local branch=$(git branch --show-current 2>/dev/null)
        [[ -n "$branch" ]] && echo "($branch)"
    fi
}

# 仮想環境のPythonバージョン表示関数
virtualenv_prompt() {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        local venv_name=$(basename "$VIRTUAL_ENV")
        local py_version=$("$VIRTUAL_ENV/bin/python" --version 2>&1 | awk '{print $2}')
        echo "($venv_name:$py_version)"
    fi
}

#　上書き
export PROMPT_COMMAND='PS1="$(virtualenv_prompt)\$(parse_git_branch)\u@\h:\w\$ "'


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
                    read -p "Do you want to run the last created script? (y/n): " confirm
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
