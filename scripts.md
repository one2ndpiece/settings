
# mermaid
mermaid live editor
```
docker run --platform linux/amd64 --publish 8000:8080 ghcr.io/mermaid-js/mermaid-live-editor
```
# Box
boxをマウント（wslで実行）
```
sudo mount -t drvfs 'C:\Users\戸波勇人\Box' /mnt/box
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


# AWS
sam local invokeに必要なオプション
```
sam build
sam local invoke --event payload.json --container-host host.docker.internal  --container-host-interface 0.0.0.0 --profile=sothink
```
cdk deploy
```
cdk deploy recovery --context acc=rentek --profile=rentek
```

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
git merge {branch} --no-ff --no-editのgitエイリアス
```
# グローバルに設定
git config --global alias.mergeno "merge --no-ff --no-edit"
# 使用方法
git mergeno {branch}
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
# github/ghコマンド
```
# githubへ接続
ssh-keygen -t ed25519
cat ~/.ssh/id_ed25519.pub
ssh -T git@github.com

# ghコマンド
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
