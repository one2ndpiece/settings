{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.one2ndpiece;
  promptConfig = builtins.readFile ../dotfiles/.config/zsh/prompt.zsh;
  scriptsConfig = builtins.readFile ../dotfiles/.config/zsh/scripts.zsh;
in
{
  options.one2ndpiece = {
    enable = lib.mkEnableOption "one2ndpiece shared development environment";

    aws.enable = lib.mkEnableOption "AWS-specific zsh integration";
    azureCli.enable = lib.mkEnableOption "Azure CLI bash completion in zsh";
    aicommit.enable = lib.mkEnableOption "the aicommit2 alias";
    clipboard.enable = lib.mkEnableOption "tmux clipboard integration through xclip";
  };

  config = lib.mkIf cfg.enable {
    xdg.enable = true;

    home.packages = [
      pkgs.fzf
      pkgs.glibcLocales
    ]
    ++ lib.optional cfg.clipboard.enable pkgs.xclip;

    home.sessionVariables = {
      LANG = "ja_JP.UTF-8";
      LC_ALL = "ja_JP.UTF-8";
      LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
    }
    // lib.optionalAttrs cfg.aws.enable {
      AWS_VAULT_BACKEND = "file";
    };

    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    programs.zsh = {
      enable = true;
      dotDir = "${config.xdg.configHome}/zsh";
      enableCompletion = true;

      history = {
        append = true;
        ignoreAllDups = true;
        ignoreDups = true;
        path = "${config.xdg.stateHome}/zsh/history";
        share = true;
      };

      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ] ++ lib.optional cfg.aws.enable "aws";
        theme = "robbyrussell";
      };

      shellAliases = lib.optionalAttrs cfg.aicommit.enable {
        aic = "aicommit2 --locale jp --generate 3";
      };

      initContent = lib.mkAfter ''
        ${promptConfig}
        ${scriptsConfig}

        if [[ -f "$HOME/.config/zsh/custom.zsh" ]]; then
          source "$HOME/.config/zsh/custom.zsh"
        fi

        ${lib.optionalString cfg.azureCli.enable ''
          autoload -Uz +X bashcompinit && bashcompinit
          if [[ -f /etc/bash_completion.d/azure-cli ]]; then
            source /etc/bash_completion.d/azure-cli
          fi
        ''}
      '';
    };

    programs.tmux = {
      enable = true;
      keyMode = "vi";
      mouse = true;
      shell = "${pkgs.zsh}/bin/zsh";
      extraConfig = ''
        set -g status-right "Pane: #{pane_id}"
        unbind -T copy-mode-vi MouseDragEnd1Pane
        unbind -T copy-mode MouseDragEnd1Pane
        bind-key -T copy-mode-vi C-n send-keys -X rectangle-toggle

        ${lib.optionalString cfg.clipboard.enable ''
          bind -T copy-mode-vi y send -X copy-pipe-and-cancel "${pkgs.xclip}/bin/xclip -in -selection clipboard"
        ''}
      '';
    };

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      withPython3 = false;
      withRuby = false;
      initLua = ''
        vim.opt.number = true
        vim.opt.cursorcolumn = true
      '';
    };
  };
}
