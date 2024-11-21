
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

# git
git merge {branch} --no-ff --no-editのgitエイリアス
```
# グローバルに設定
git config --global alias.mergeno "merge --no-ff --no-edit"
# 使用方法
git mergeno {branch}
```