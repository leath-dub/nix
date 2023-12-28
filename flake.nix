{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Utils
    systems.url = "github:nix-systems/default";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-conf.url = "github:leath-dub/nvim";
    sxhkd-conf.url = "github:leath-dub/sxhkd-conf/alpine";
    bspwm-conf.url = "github:leath-dub/bspwm/alpine";

    # Custom packages
    vbooxd.url = "github:leath-dub/vboox";

    # Overlays
    nixgl.url = "github:guibou/nixGL";

    # Other packages
    templ.url = "github:a-h/templ";
  };

  outputs = inputs@{ self, nixpkgs, systems, home-manager, ... }: let
    username = "cathal";
    forAllSystems = fn:
      nixpkgs.lib.genAttrs (import systems) (system: fn { pkgs = nixpkgs.legacyPackages.${system} // { overlays = [ inputs.nixgl.overlay inputs.vbooxd.overlays.default inputs.templ.overlays.default ]; }; inherit system; });
    in {
      hm = forAllSystems ({ pkgs, system }: {
        "${username}" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [
            ./home-manager/${username}/home.nix
          ];

          extraSpecialArgs = with inputs; {
            inherit username neovim-conf sxhkd-conf system bspwm-conf;
          };
        };
      });

      packages = forAllSystems ({ pkgs, system }: {
        default = self.hm.${system}.${username}.activationPackage;
      });
    };
}
