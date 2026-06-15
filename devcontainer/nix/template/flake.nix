{
  description = "Project development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    settings.url = "github:one2ndpiece/settings";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      settings,
      ...
    }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      forAllSystems = nixpkgs.lib.genAttrs systems;

      homeConfigurationFor =
        system:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          modules = [
            settings.homeManagerModules.default
            ./home-manager/root-devcontainer.nix
          ];
        };

      homeConfigurationName = system: "root-devcontainer-${system}";
    in
    {
      homeConfigurations = nixpkgs.lib.listToAttrs (
        map (
          system: nixpkgs.lib.nameValuePair (homeConfigurationName system) (homeConfigurationFor system)
        ) systems
      );

      packages = forAllSystems (
        system:
        let
          activationPackage = self.homeConfigurations.${homeConfigurationName system}.activationPackage;
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
          meta.description = "Activate the root devcontainer Home Manager profile";
        };
      });

      formatter = forAllSystems (system: (import nixpkgs { inherit system; }).nixfmt);
    };
}
