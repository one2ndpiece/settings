{ pkgs, ... }:

{
  home.packages = [
    pkgs.fzf
    pkgs.glibcLocales
    pkgs.neovim
    pkgs.nixfmt
    pkgs.oh-my-zsh
    pkgs.tmux
    pkgs.zsh
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    LANG = "ja_JP.UTF-8";
    LC_ALL = "ja_JP.UTF-8";
    LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
    VISUAL = "nvim";
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
