{ username, neovim-conf, bspwm-conf, config, pkgs, ... }:

{

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "23.11";
  };

  home.file = {
    nix-conf = {
      enable = true;
      source = ../../system/nix.conf;
      target = "./.config/nix/nix.conf";
    };

    neovim-conf = {
      enable = true;
      source = neovim-conf;
      target = "./.config/nvim";
    };

    bspwm-conf = {
      enable = true;
      source = bspwm-conf;
      target = bspwm-conf.dest;
    };
  };

  home.packages = with pkgs; [
    gcc
    nodejs
    go
    skim
  ];

  programs = {
    git = {
      enable = true;
      userName = "leath-dub";
      userEmail = "fierceinbattle@gmail.com";
      extraConfig = {
        init.defaultBranch = "main";
        color.ui = "auto";
      };
    };

    neovim.enable = true;
  };
}
