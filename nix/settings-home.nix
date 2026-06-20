{ pkgs, ... }:

{
  home.packages = with pkgs; [
    biome
    curl
    gh
    jq
    nodejs
    openssh
    ripgrep
    ruff
    tree
    unzip
    uv
    zip
  ];

  programs = {
    git = {
      enable = true;
      lfs.enable = true;
      settings = {
        core.quotepath = false;
        credential.helper = "cache --timeout=86400";
        safe.directory = "/workspace/settings";
      };
    };

    home-manager.enable = true;
  };
}
