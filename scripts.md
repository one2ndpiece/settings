# AWS

### session-manager-pluginをインストール
AWS CLIのECRコマンドでコンテナ内のコマンドを実行
```
curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"
dpkg -i session-manager-plugin.deb
```
コンテナ内のコマンドを実行
```
aws ecs execute-command --cluster $CLUSTER --task $TASK --container web --interactive --command "printenv"
```
ポートフォワーディング
EC2にて。(debian)
```
sudo apt install snapd -y

# 確認
sudo systemctl status snapd

sudo snap install amazon-ssm-agent --classic

# 確認
sudo systemctl status amazon-ssm-agent
```
コントロール側で。
```
aws ssm describe-instance-information 
aws ssm start-session --target "i-07799feaf42145e07" --document-name AWS-StartPortForwardingSessionToRemoteHost --parameters '{"portNumber":["3306"],"localPortNumber":["1053"],"host":["10.0.3.104"]}'
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
## ものレポで使うコマンド
Part1
```
# リポジトリをクローン
git clone --depth 1 --filter=blob:none --sparse https://github.com/tanstack/table.git

# クローンしたディレクトリに移動
cd table

# 必要なディレクトリをチェックアウト
git sparse-checkout set examples/react/editable-data
```
Part2 こっちの方が使えるかも
```
git clone --filter=blob:none --no-checkout https://github.com/aws/aws-cdk.git
cd aws-cdk
git sparse-checkout init --cone
git sparse-checkout set packages/aws-cdk-lib/aws-rds
git checkout main
```
## .gitattributes
```
git config merge.ours.driver true
```
```.gitattributes
.gitignore merge=ours

```
## delta

```
cargo install git-delta
```
```.gitconfig
[core]
  pager = delta
[interactive]
  diffFilter = delta --color-only
[delta]
	side-by-side = true
  diff-so-fancy=true
  keep-plus-minus-markers=true
  minus-emph-style="bold 94 89"
  plus-emph-style="bold 29 29"
  hunk-header-style="omit"
  line-numbers=true
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
権限が足りない時
```
chmod 600 ~/.ssh/id_ed25519_one2ndpiece
```
## gh
```
gh auth login
```
### editorをcursorに設定
```
gh config set editor "cursor --wait"

```
### secretを設定
```
gh secret set TOKEN_JSON --repo <owner>/<repo> < data/token.json
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
# C#
## ctags
methodやclassを解析
cmはclassとmethodの意味
```
ctags -x --languages=C# --kinds-C#=cm file.cs
```
## dotnet C#
```
apt update && apt install -y dotnet-sdk-9.0
dotnet --version

# 新規プロジェクト作成
dotnet new console -o .

# 実行
dotnet run
```
別バージョンをinstallしたい時
```
apt remove -y dotnet-sdk-7.0 dotnet-host-7.0
apt install -y dotnet-sdk-9.0
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

# Azure CLI
install
```
curl -sL https://aka.ms/InstallAzureCLIDeb | bash
```
az login
```
az login --service-principal -u {application_id} -p {client_secret} --tenant {tenant_id} --allow-no-subscriptions
```
access tokenを取得
```
az account get-access-token
```

# Docker
```
docker compose up --build --watch
```
```
aws ecr create-repository --repository-name my-repository --region <your-region>
docker build --target prd -t my-app:latest -f docker/Dockerfile .
docker tag my-app:latest <aws_account_id>.dkr.ecr.<your-region>.amazonaws.com/my-repository:latest
docker push <aws_account_id>.dkr.ecr.<your-region>.amazonaws.com/my-repository:latest
```

# npmとnvm
```
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash &&\
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")" &&\
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" &&\
nvm install node &&\
nvm use node
```

# java
```
# install java
apt install openjdk-21-jdk

# install sdkman これがあったらjavaもインストールできる？？
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install maven
sdk install springboot
```

# Markdown PDF
必要なパッケージ
```
apt update && apt install -y \
  gconf-service libasound2 libatk1.0-0 libc6 libcairo2 libcups2 \
  libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 \
  libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 \
  libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 \
  libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 \
  libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 \
  libxtst6 ca-certificates fonts-liberation libappindicator1 \
  libnss3 lsb-release xdg-utils wget
```
