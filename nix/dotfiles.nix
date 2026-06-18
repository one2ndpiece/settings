{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.userProfile;
in
{
  options.userProfile = {
    enable = lib.mkEnableOption "shared dotfiles profile";

    aws.enable = lib.mkEnableOption "AWS-specific zsh integration";
    azureCli.enable = lib.mkEnableOption "Azure CLI bash completion in zsh";
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
    // lib.optionalAttrs cfg.clipboard.enable {
      "tmux/clipboard-xclip.conf".source = ../dotfiles/.config/tmux/clipboard-xclip.conf;
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
