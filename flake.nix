{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "flake:nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    neovim-conf.url = "github:leath-dub/nvim";
    bspwm-conf.url = "github:leath-dub/bspwm";
  };

  outputs = { self, nixpkgs, home-manager, flake-utils, neovim-conf, bspwm-conf, ... }:
    flake-utils.lib.eachDefaultSystem (system: let 
      username = "cathal";
      pkgs = import nixpkgs {
        inherit system;
      };
    in {
      packages.default = self.package.${system}.homeConfigurations.${username}.activationPackage;
      package.homeConfigurations = {
        "${username}" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./home-manager/${username}/home.nix
          ];
          extraSpecialArgs = {
            inherit username neovim-conf bspwm-conf;
          };
        };
      };
    });
}
