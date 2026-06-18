SETTINGS_ROOT := "../../"
set working-directory := SETTINGS_ROOT

# Scratch commands migrated from scripts.md.
# These recipes are intentionally explicit. Install recipes may change the host/container.

# list
default:
  just --list misc

# install AWS Session Manager plugin on Ubuntu/Debian
aws-session-manager-plugin-install:
  #!/usr/bin/env bash
  set -euo pipefail
  curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"
  sudo dpkg -i session-manager-plugin.deb

# run a command in an ECS container through AWS CLI
aws-ecs-exec cluster task container="web" command="printenv":
  aws ecs execute-command --cluster "{{cluster}}" --task "{{task}}" --container "{{container}}" --interactive --command "{{command}}"

# install amazon-ssm-agent through snap on Debian/Ubuntu
aws-ssm-agent-install-snap:
  #!/usr/bin/env bash
  set -euo pipefail
  sudo apt install snapd -y
  sudo systemctl status snapd
  sudo snap install amazon-ssm-agent --classic
  sudo systemctl status amazon-ssm-agent

# list SSM managed instances
aws-ssm-instances:
  aws ssm describe-instance-information

# start SSM port forwarding session to a remote host
aws-ssm-port-forward target remote_host remote_port="3306" local_port="1053":
  #!/usr/bin/env bash
  set -euo pipefail
  aws ssm start-session \
    --target "{{target}}" \
    --document-name AWS-StartPortForwardingSessionToRemoteHost \
    --parameters "{\"portNumber\":[\"{{remote_port}}\"],\"localPortNumber\":[\"{{local_port}}\"],\"host\":[\"{{remote_host}}\"]}"

# run an AWS command in all regions through scripts/misc/aws-all-regions
aws-all-regions command:
  scripts/misc/aws-all-regions -- {{command}}

# fix ownership for a WSL workspace path
wsl-chown path user="USER" group="GROUP":
  sudo chown -R "{{user}}:{{group}}" "{{path}}"

# configure Poetry to create virtualenvs in the project
poetry-in-project:
  poetry config --local virtualenvs.in-project true

# install project dependencies through Poetry
poetry-install:
  poetry install

# enter Poetry shell
poetry-shell:
  poetry shell

# install uv using the official installer
uv-install:
  curl -LsSf https://astral.sh/uv/install.sh | sh

# pin Python version through uv
uv-python-pin version:
  uv python pin "{{version}}"

# sync uv project
uv-sync:
  uv sync

# list Python versions known by uv
uv-python-list:
  uv python list

# run a file through uv
uv-run file:
  uv run "{{file}}"

# install a package through uv tool install
uv-install-package package:
  uv install "{{package}}"

# pip install through uv
uv-pip-install package:
  uv pip install "{{package}}"

# pip uninstall through uv
uv-pip-uninstall package:
  uv pip uninstall "{{package}}"

# list packages through uv pip
uv-pip-list:
  uv pip list

# prune deleted remote branches locally
git-fetch-prune:
  git fetch --prune

# configure common global git aliases
git-setup-aliases:
  git config --global alias.mergeno "merge --no-ff --no-edit"
  git config --global alias.log-all "log --oneline --all --graph"

# configure Git editor to Cursor
git-editor-cursor:
  git config --global core.editor "cursor --wait"

# sparse clone a repository with one path
git-sparse-clone repo path dir="repo":
  #!/usr/bin/env bash
  set -euo pipefail
  git clone --filter=blob:none --no-checkout "{{repo}}" "{{dir}}"
  cd "{{dir}}"
  git sparse-checkout init --cone
  git sparse-checkout set "{{path}}"
  git checkout main

# enable merge=ours driver globally
git-merge-ours-driver:
  git config merge.ours.driver true

# install git-delta through cargo
git-delta-install-cargo:
  cargo install git-delta

# generate a GitHub SSH key
github-ssh-key name:
  ssh-keygen -t ed25519 -f "$HOME/.ssh/id_ed25519_{{name}}"
  cat "$HOME/.ssh/id_ed25519_{{name}}.pub"

# test GitHub SSH auth
github-ssh-test:
  ssh -T git@github.com

# set origin to a GitHub SSH host alias
github-remote-set-url host account repo:
  git remote set-url origin "git@{{host}}:{{account}}/{{repo}}.git"

# fix SSH private key permission
ssh-key-chmod key="$HOME/.ssh/id_ed25519":
  chmod 600 "{{key}}"

# authenticate gh
gh-auth-login:
  gh auth login

# configure gh editor to Cursor
gh-editor-cursor:
  gh config set editor "cursor --wait"

# set GitHub Actions secret from a file
gh-secret-set repo secret file:
  gh secret set "{{secret}}" --repo "{{repo}}" < "{{file}}"

# install ngrok through apt without sudo
ngrok-install-apt:
  #!/usr/bin/env bash
  set -euo pipefail
  curl -sSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc \
    | tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null
  echo "deb https://ngrok-agent.s3.amazonaws.com buster main" \
    | tee /etc/apt/sources.list.d/ngrok.list
  apt update
  apt install ngrok

# expose an HTTP URL through ngrok
ngrok-http url="http://localhost:5173":
  ngrok http "{{url}}"

# DNS lookup with nslookup and dig
dns-lookup host:
  nslookup "{{host}}"
  dig "{{host}}"

# traceroute a host
trace-route host:
  traceroute "{{host}}"

# ping a host
ping-host host:
  ping "{{host}}"

# telnet to host and port
telnet-host host port:
  telnet "{{host}}" "{{port}}"

# print common command versions
check-versions:
  #!/usr/bin/env bash
  set -euo pipefail
  for cmd in aws pyenv cdk npm python sam; do
    if command -v "$cmd" >/dev/null 2>&1; then
      echo "== $cmd =="
      "$cmd" --version || true
    else
      echo "== $cmd: not found =="
    fi
  done
  which python || true
  pyenv versions || true

# print shell options
shell-options:
  set -o

# source tmux config
tmux-source config="$HOME/.tmux.conf":
  tmux source-file "{{config}}"

# show tmux copy-mode hint
tmux-copy-help:
  @echo 'Ctrl+b then [ enters copy-mode; q exits.'

# inspect C# classes and methods with ctags
ctags-csharp file:
  ctags -x --languages=C# --kinds-C#=cm "{{file}}"

# install .NET SDK 9.0 on apt-based systems
dotnet-install-9:
  sudo apt update
  sudo apt install -y dotnet-sdk-9.0
  dotnet --version

# switch apt-based system to .NET SDK 9.0
dotnet-switch-9:
  sudo apt remove -y dotnet-sdk-7.0 dotnet-host-7.0
  sudo apt install -y dotnet-sdk-9.0

# create .NET console project in current directory
dotnet-new-console:
  dotnet new console -o .

# run .NET project
dotnet-run:
  dotnet run

# create a .NET Lambda EmptyFunction project
dotnet-new-lambda name="HelloLambda":
  dotnet new lambda.EmptyFunction --name "{{name}}"

# add API Gateway event package to a Lambda project
dotnet-add-apigateway-events project="./src/HelloLambda/HelloLambda.csproj":
  dotnet add "{{project}}" package Amazon.Lambda.APIGatewayEvents

# install zsh through apt
zsh-install-apt:
  sudo apt install zsh

# install Oh My Zsh using the official installer
oh-my-zsh-install:
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# install Azure CLI
azure-cli-install:
  curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Azure service principal login
azure-login-sp application_id client_secret tenant_id:
  az login --service-principal -u "{{application_id}}" -p "{{client_secret}}" --tenant "{{tenant_id}}" --allow-no-subscriptions

# get Azure access token
azure-token:
  az account get-access-token

# docker compose up with build and watch
docker-compose-watch:
  docker compose up --build --watch

# build and push an image to ECR
docker-ecr-build-push account_id region repository image="my-app:latest" dockerfile="docker/Dockerfile" target="prd":
  #!/usr/bin/env bash
  set -euo pipefail
  aws ecr create-repository --repository-name "{{repository}}" --region "{{region}}" || true
  docker build --target "{{target}}" -t "{{image}}" -f "{{dockerfile}}" .
  remote="{{account_id}}.dkr.ecr.{{region}}.amazonaws.com/{{repository}}:latest"
  docker tag "{{image}}" "$remote"
  docker push "$remote"

# install nvm and latest node
nvm-install-node:
  #!/usr/bin/env bash
  set -euo pipefail
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
  export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  nvm install node
  nvm use node

# install OpenJDK 21
java-install-21:
  sudo apt install openjdk-21-jdk

# install SDKMAN, Maven, and Spring Boot
sdkman-install-java-tools:
  #!/usr/bin/env bash
  set -euo pipefail
  curl -s "https://get.sdkman.io" | bash
  # shellcheck disable=SC1091
  source "$HOME/.sdkman/bin/sdkman-init.sh"
  sdk install maven
  sdk install springboot

# install packages needed by Markdown PDF / Chromium based renderers
markdown-pdf-deps-install:
  sudo apt update
  sudo apt install -y \
    gconf-service libasound2 libatk1.0-0 libc6 libcairo2 libcups2 \
    libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 \
    libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 \
    libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 \
    libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 \
    libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 \
    libxtst6 ca-certificates fonts-liberation libappindicator1 \
    libnss3 lsb-release xdg-utils wget
