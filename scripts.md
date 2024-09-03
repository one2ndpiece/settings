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


mermaid live editor
```
docker run --platform linux/amd64 --publish 8000:8080 ghcr.io/mermaid-js/mermaid-live-editor
```

boxをマウント（wslで実行）
```
sudo mount -t drvfs 'C:\Users\戸波勇人\Box' /mnt/box
```

sam local invokeに必要なオプション
```
sam local invoke --event payload.json --container-host host.docker.internal  --container-host-interface 0.0.0.0 --profile=sothink
```

コマンドを消すコマンド
Ctrl + u

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

ollama & aicommit2
```
ollama serve
docker run -d -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama # 別コンテナで起動
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ollama ＃コンテナのipをチェック

ollama pull gemma2 //Optional

aicommit2 config set OLLAMA.host=http://172.17.0.4:11434
aicommit2 config set OLLAMA.model=gemma2
aic
```

WSLにてファイル権限が変わることがある
```
sudo chown -R tonami:tonami /workspace/rentek
```

poetry
```
poetry config --local virtualenvs.in-project true
poetry install
poetry shell    
```