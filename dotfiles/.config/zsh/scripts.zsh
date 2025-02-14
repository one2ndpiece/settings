#---------------------------------------------
aws_profile() {
    # unset（または -u, --unset ）の場合は解除する
    if [[ "$1" == "unset" || "$1" == "-u" || "$1" == "--unset" ]]; then
        unset AWS_PROFILE
        echo "AWS_PROFILE has been unset."
        return 0
    fi

    # 引数がなければ使用法を表示
    if [[ -z "$1" || "$1" == "--help" || "$1" == "-h" ]]; then
        echo "Usage: aws_profile <profile> | aws_profile unset"
        return 1
    fi

    local profile="$1"

    # ~/.aws/credentials に該当プロファイルが存在するかチェック
    if ! grep -q "^\[$profile\]" ~/.aws/credentials 2>/dev/null; then
        echo "Error: Profile '$profile' not found in ~/.aws/credentials"
        return 1
    fi

    export AWS_PROFILE="$profile"
    echo "AWS_PROFILE is now set to '$AWS_PROFILE'"
    # オプション: 現在の認証情報を表示する
    aws sts get-caller-identity --output table |cat
}
#---------------------------------------------
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