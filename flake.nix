{
  description = "one2ndpiece shared Nix outputs";

  outputs = _: {
    homeManagerModules = {
      dotfiles = import ./nix/dotfiles.nix;
      profile = import ./nix/profile.nix;
    };
  };
}
