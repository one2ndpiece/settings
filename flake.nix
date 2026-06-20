{
  description = "one2ndpiece shared settings";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      forAllSystems = nixpkgs.lib.genAttrs systems;

      pkgsFor = system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

      settingsHomeConfigurationName = system: "root-settings-${system}";

      settingsHomeConfigurationFor =
        system:
        let
          pkgs = pkgsFor system;
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            self.homeManagerModules.profile
            self.homeManagerModules.dotfiles
            self.homeManagerModules.aws
            ./nix/settings-home.nix
            {
              home = {
                username = "root";
                homeDirectory = "/root";
                stateVersion = "26.05";
              };

              aws.enable = false;
              dotfiles.clipboard.enable = true;
            }
          ];
        };
    in
    {
      homeManagerModules = {
        aws = import ./nix/aws.nix;
        dotfiles = import ./nix/dotfiles.nix;
        profile = import ./nix/profile.nix;
      };

      homeConfigurations = nixpkgs.lib.listToAttrs (
        map (
          system:
          nixpkgs.lib.nameValuePair
            (settingsHomeConfigurationName system)
            (settingsHomeConfigurationFor system)
        ) systems
      );

      packages = forAllSystems (
        system:
        let
          activationPackage =
            self.homeConfigurations.${settingsHomeConfigurationName system}.activationPackage;
        in
        {
          home-activation = activationPackage;
          default = activationPackage;
        }
      );

      apps = forAllSystems (system: {
        home-activate = {
          type = "app";
          program = "${self.packages.${system}.home-activation}/activate";
          meta.description = "Activate the settings repository Home Manager profile";
        };
      });

      checks = forAllSystems (system: {
        home-activation = self.packages.${system}.home-activation;
      });

      formatter = forAllSystems (system: (pkgsFor system).nixfmt);
    };
}
