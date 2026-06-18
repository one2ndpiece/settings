{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.dotfiles;
in
{
  options.dotfiles = {
    clipboard.enable = lib.mkEnableOption "tmux clipboard integration through xclip";
  };

  config = {
    xdg.enable = true;

    home.packages = lib.optional cfg.clipboard.enable pkgs.xclip;

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
    // lib.optionalAttrs cfg.clipboard.enable {
      "tmux/clipboard-xclip.conf".source = ../dotfiles/.config/tmux/clipboard-xclip.conf;
    };
  };
}
