{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "flake:nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    }; 
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, home-manager, flake-utils, ... } @ inputs:
    flake-utils.lib.eachDefaultSystem (system: let
      username = "cathal";
      pkgs = import nixpkgs {
        inherit system;
      };
    in rec {
       packages = flake-utils.lib.flattenTree {
       homeConfigurations = {
        "${username}" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            {
              home = {
                inherit username;
                homeDirectory = /home/${username};
                stateVersion = "23.11-pre";
              };
              programs.home-manager.enable = true;
            }
          ];
          extraSpecialArgs = {
            inherit inputs system;
          };
        };
      };
      };
    });
}
