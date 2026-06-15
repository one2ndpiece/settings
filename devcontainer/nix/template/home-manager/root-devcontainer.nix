{ pkgs, ... }:

{
  home = {
    username = "root";
    homeDirectory = "/root";
    stateVersion = "26.05";

    packages = with pkgs; [
      curl
      gh
      jq
      just
      openssh
      ripgrep
      tree
      unzip
      zip
    ];
  };

  programs = {
    git = {
      enable = true;
      lfs.enable = true;
      settings = {
        core.quotepath = false;
        credential.helper = "cache --timeout=86400";
      };
    };

    home-manager.enable = true;
  };

  one2ndpiece = {
    enable = true;
    aws.enable = false;
    azureCli.enable = false;
    aicommit.enable = false;
    clipboard.enable = false;
  };
}
