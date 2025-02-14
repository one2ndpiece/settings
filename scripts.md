
# mermaid
mermaid live editor
```
docker run --platform linux/amd64 --publish 8000:8080 --rm --pull always ghcr.io/mermaid-js/mermaid-live-editor

```
# Box
boxをマウント（wslで実行）
```
sudo mount -t drvfs 'C:\Users\戸波勇人\Box' /mnt/box
```

# AWS
## sam
### sam local invokeに必要なオプション
```
sam build
sam local invoke --event payload.json --container-host host.docker.internal  --container-host-interface 0.0.0.0 --profile=sothink
```
### sam local start-apiに必要なオプション
```
sam build
sam local start-api --container-host host.docker.internal  --container-host-interface 0.0.0.0
```
## cdk
cdk deploy
```
cdk deploy recovery --context acc=rentek --profile=rentek
```
## quicksight
Quicksightダッシュボードのリストを取得
```
aws quicksight list-dashboards --aws-account-id 339713146909 --profile rentek | jq '.DashboardSummaryList[] | {DashboardId, Name}'
```

Quicksightダッシュボードのリストを取得(詳細版)
```
aws quicksight list-dashboards --aws-account-id 339713146909 --profile rentek
```
QuickSightのデータセット
```
# データセットを取得。jqでデータセットIDと名前を取得。OR条件
aws quicksight list-data-sets --aws-account-id 339713146909 --profile rentek | jq '.DataSetSummaries[] | select(.Name | contains("PL") or contains("サマリ")) | {DataSetId, Name}'

# AND条件
aws quicksight list-data-sets --aws-account-id 339713146909 --profile rentek | jq '.DataSetSummaries[] | select(.Name | contains("PL") and (contains("アーカイブ") | not)) | {DataSetId, Name}'

# データセットを更新
aws quicksight create-ingestion --aws-account-id 123456789012 --data-set-id sales-data-set --ingestion-id "ingestion-$(date +%Y%m%d%H%M%S)"

```
lambdaを実行　grepは要編集　最初は実行はせずに、リストだけで確認した方がいい
```
aws lambda list-functions --query "Functions[].FunctionName" --profile rentek  | grep -- "-tes
t" | grep -- "-All" | tr -d '",' | tee /dev/tty | xargs -I {} aws lambda invoke --function-name {} --log-type Tail /workspace/rentek/tempo/{}.log --profile rentek --cli-read-timeout 120
```

## aws-vaultのインストール
今は事足りているかな～、そんなにprofileを打つことが多くないし
```
# 最新バージョンを確認してダウンロード
wget https://github.com/99designs/aws-vault/releases/latest/download/aws-vault-linux-amd64

# 実行可能にする
chmod +x aws-vault-linux-amd64

# システムのPATHに移動
sudo mv aws-vault-linux-amd64 /usr/local/bin/aws-vault

# バックエンドをfileに設定を.bashrcに追加
echo 'export AWS_VAULT_BACKEND=file' >> ~/.bashrc

# バックエンドをfileに設定
echo $AWS_VAULT_BACKEND

```
コマンド
```
aws-vault --version
aws-vault exec {profile}
```

## ECR
```
# sothink アカウント
AWS_ECR=115767075872.dkr.ecr.ap-southeast-2.amazonaws.com

aws ecr get-login-password --profile sothink | docker login --username AWS --password-stdin $AWS_ECR
```

# ollama & aicommit2
ollama & aicommit2
```
ollama serve
docker run -d -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama # 別コンテナで起動
docker ps -a | grep 'ollama' # すでにイメージがあるか確認
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ollama ＃コンテナのipをチェック

ollama pull gemma2 //Optional

aicommit2 config set OLLAMA.host=http://172.17.0.4:11434
aicommit2 config set OLLAMA.model=gemma2

aicommit2 config set GROQ.model="gemma2-9b-it"
key=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

```

# WSL
WSLにてファイル権限が変わることがある
```
sudo chown -R tonami:tonami /workspace/rentek
```

# poetry
```
poetry config --local virtualenvs.in-project true
poetry install
poetry shell    
```
# uv
```
curl -LsSf https://astral.sh/uv/install.sh | sh
uv python pin <version>
uv sync
uv python list
uv run <file>
uv install <package>
uv pip install <package>
uv pip uninstall <package>
uv pip list
```

# git
gitのリモートブランチの削除をローカルのブランチに反映させる
```
git fetch --prune
```
git merge {branch} --no-ff --no-editのgitエイリアス
```
# グローバルに設定
git config --global alias.mergeno "merge --no-ff --no-edit"
# 使用方法
git mergeno {branch}

# logの表示エイリアス
git config --global alias.log-all "log --oneline --all --graph"

# git editorをcursorに設定
export GIT_EDITOR="cursor --wait"
```
ものレポで使うコマンド
```
# リポジトリをクローン
git clone --depth 1 --filter=blob:none --sparse https://github.com/tanstack/table.git

# クローンしたディレクトリに移動
cd table

# 必要なディレクトリをチェックアウト
git sparse-checkout set examples/react/editable-data

```
# github
```
# githubへ接続
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_{somethig}
cat ~/.ssh/id_ed25519.pub
ssh -T git@github.com
```
## .ssh/config

```
# アカウント1用設定
Host github.com-yttnm
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519

# アカウント2用設定
Host github.com-one2ndpiece
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_one2ndpiece
```
このconfigの場合git@{Host}:{github-account}/{repository name}.gitとしなければならない。
以下がその例
```
git remote set-url origin git@yttnm:yttnm/universal-hub.git
```

## gh
```
gh auth login
```

# ngrok
ここに全部書いてある
https://dashboard.ngrok.com/get-started/setup/linux
sudoを抜いたコマンド
```
curl -sSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc \
	|  tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null \
	&& echo "deb https://ngrok-agent.s3.amazonaws.com buster main" \
	|  tee /etc/apt/sources.list.d/ngrok.list \
	&&  apt update \
	&&  apt install ngrok

# remixのデフォルトポート
ngrok http http://localhost:5173
```

# ネットワーク調べる計算
```
# ホスト名を調べる
nslookup
dig

# ルーティングを調べる
traceroute

# ネットワークの疎通を調べる
ping

# ネットワークの疎通を調べる
telnet

```
# bash
最初の確認コマンド
```
aws --version
pyenv --version
cdk --version
npm --version
python --version
which python
pyenv versions
aicommit2 --version
cdk --version
sam --version
```
コマンドを消すコマンド
```
Ctrl + u
```
```
# シェルの設定確認
set -o
# シェルの設定を変更 emacsがデフォルト
set -o emacs
set -o vi
```
# viでの操作を想定して
## ノーマルモード
```
# テキストファイルモード？複数行がかける
v
```
# tmux
`.tmux.conf`
```
setw -g mode-keys vi
```
これを追加して以下を実行
```
tmux source-file ~/.tmux.conf
```
便利ショートカット
```
# コピーモード
Ctrl + b → [
qで抜ける
```

# dotnet C#
```
apt update && apt install -y dotnet-sdk-8.0
dotnet --version

# 新規プロジェクト作成
dotnet new console -o .

# 実行
dotnet run
```
## sam local start-apiをするための準備
```
# 新規プロジェクト作成
dotnet new lambda.EmptyFunction --name HelloLambda
# パッケージ追加
dotnet dotnet add ./src/HelloLambda/HelloLambda.csproj package Amazon.Lambda.APIGatewayEvents

```

# zsh
```
apt install zsh
```
## oh-my-zsh
```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

