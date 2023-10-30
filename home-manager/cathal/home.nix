{ username, neovim-conf, config, pkgs, ... }:

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
  };

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
