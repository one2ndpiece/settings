{
  description = "one2ndpiece shared Nix outputs";

  outputs = _: {
    homeManagerModules = {
      aws = import ./nix/aws.nix;
      dotfiles = import ./nix/dotfiles.nix;
      profile = import ./nix/profile.nix;
    };
  };
}
