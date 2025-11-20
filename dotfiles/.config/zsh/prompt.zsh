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

AWS_PROFILEの表示関数
aws_profile_prompt() {
    if [[ -n "$AWS_VAULT" ]]; then
        echo "(aws-vault:$AWS_VAULT)"
    else
        echo ""
    fi
}

_1st_line() {
    local venv=$(virtualenv_prompt)
    local aws_profile=$(aws_profile_prompt)
    local text="\n${venv}($PWD)($(TZ=JST-9 date '+%Y-%m-%d %H:%M:%S'))${aws_profile}"
    echo "${text}"
}

# precmd フック用の関数（プロンプト表示前に1段目を出力）
_print_first_line() {
    echo "$(_1st_line)"
}

# precmd_functions 配列に追加して、毎回プロンプト前に実行させる
precmd_functions+=( _print_first_line )


export VIRTUAL_ENV_DISABLE_PROMPT=1
