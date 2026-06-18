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
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            settings.homeManagerModules.default
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
                clipboard.enable = false;
              };
            }
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
