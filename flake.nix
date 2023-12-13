{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-conf.url = "github:leath-dub/nvim";
    sxhkd-conf.url = "github:leath-dub/sxhkd-conf";
  };

  outputs = { self, nixpkgs, systems, home-manager, neovim-conf, sxhkd-conf, ... }: let
    username = "cathal";
    forAllSystems = fn:
      nixpkgs.lib.genAttrs (import systems) (system: fn { pkgs = nixpkgs.legacyPackages.${system}; inherit system; });
    in {
      hm = forAllSystems ({ pkgs, system }: {
        "${username}" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./home-manager/${username}/home.nix
          ];
          extraSpecialArgs = {
            inherit username neovim-conf sxhkd-conf system;
          };
        };
      });
      packages = forAllSystems ({ pkgs, system }: {
        default = self.hm.${system}.${username}.activationPackage;
      });
    };
}
