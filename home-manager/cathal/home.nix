{ username, config, pkgs, ... }:

{
  home = {
    inherit username;
    homeDirectory = /home/${username};
    stateVersion = "23.11";
  };
  programs.git = {
    enable = true;
    userName = "leath-dub";
    userEmail = "fierceinbattle@gmail.com";
  };
}
