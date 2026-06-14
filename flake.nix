{
  description = "one2ndpiece shared Home Manager modules";

  outputs = { self }: {
    homeManagerModules = {
      default = import ./home-manager;
      personal = self.homeManagerModules.default;
    };
  };
}
