autoload -Uz +X bashcompinit && bashcompinit
if [[ -f /etc/bash_completion.d/azure-cli ]]; then
    source /etc/bash_completion.d/azure-cli
fi
