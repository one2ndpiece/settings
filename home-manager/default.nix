{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.one2ndpiece;
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
      pkgs.neovim
      pkgs.oh-my-zsh
      pkgs.tmux
      pkgs.zsh
    ]
    ++ lib.optional cfg.clipboard.enable pkgs.xclip;

    home.sessionVariables = {
      EDITOR = "nvim";
      LANG = "ja_JP.UTF-8";
      LC_ALL = "ja_JP.UTF-8";
      LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
      VISUAL = "nvim";
    }
    // lib.optionalAttrs cfg.aws.enable {
      AWS_VAULT_BACKEND = "file";
    };

    home.file = {
      ".tmux.conf".source = ../dotfiles/.config/tmux/.tmux.conf;
      ".zshenv".source = ../dotfiles/.zshenv;
    };

    xdg.configFile = {
      "nvim/init.lua".source = ../dotfiles/.config/nvim/init.lua;
      "zsh/.zshrc".source = ../dotfiles/.config/zsh/.zshrc;
      "zsh/ohmyzsh".source = "${pkgs.oh-my-zsh}/share/oh-my-zsh";
      "zsh/prompt.zsh".source = ../dotfiles/.config/zsh/prompt.zsh;
    }
    // lib.optionalAttrs cfg.aws.enable {
      "zsh/modules/aws.before.zsh".source = ../dotfiles/.config/zsh/modules/aws.before.zsh;
    }
    // lib.optionalAttrs cfg.azureCli.enable {
      "zsh/modules/azure.zsh".source = ../dotfiles/.config/zsh/modules/azure.zsh;
    }
    // lib.optionalAttrs cfg.aicommit.enable {
      "zsh/modules/aicommit.zsh".source = ../dotfiles/.config/zsh/modules/aicommit.zsh;
    }
    // lib.optionalAttrs cfg.clipboard.enable {
      "tmux/clipboard-xclip.conf".source = ../dotfiles/.config/tmux/clipboard-xclip.conf;
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
