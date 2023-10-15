{ username, config, pkgs, }:

{
  home = {
    inherit username;
    homeDirectory = /home/${username};
    stateVersion = "23.11";
  };
}
