{ config, lib, ... }:

let
  cfg = config.aws;
in
{
  options.aws = {
    enable = lib.mkEnableOption "AWS development profile";
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables = {
      AWS_VAULT_BACKEND = "file";
    };
  };
}
