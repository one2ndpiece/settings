{
  description = "one2ndpiece shared Nix outputs";

  outputs = { self }: {
    homeManagerModules = {
      default = import ./nix/dotfiles.nix;
      personal = self.homeManagerModules.default;
    };
  };
}
