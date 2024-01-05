{ username, neovim-conf, sxhkd-conf, system, bspwm-conf, config, pkgs, ... }:

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

    sxhkd-conf = {
      enable = true;
      source = sxhkd-conf;
      target = "./.config/sxhkd";
    };

    wallpaper = {
      enable = true;
      text = ''
      totoro.jpg
      '';
      target = "./Pictures/.wallpaper";
    };

    bspwm-conf = {
      enable = true;
      source = bspwm-conf;
      target = "./.config/bspwm";
    };

    nerdfont = {
      enable = true;
      source = import ../../modules/nerdfont.nix pkgs;
      target = "./.local/share/fonts/NerdFontSymbols";
    };

    zig = {
      enable = true;
      source = import ../../modules/zig.nix pkgs;
      target = "./.local/bin/zig";
    };

    cursor = {
      enable = true;
      source = import ../../modules/cursor.nix pkgs;
      target = "./.local/share/icons/";
    };

    cursor_enable = {
      enable = true;
      text = ''
      [icon theme]
      Inherits=macOS-BigSur-White
      '';
      target = "./.icons/default/index.theme";
    };

    xresources = {
      enable = true;
      text = ''
      Xcursor.theme: macOS-BigSur-White
      Xcursor.size: 28
      '';
      target = "./.Xresources";
    };
  };

  home.packages = with pkgs; [
    gcc
    nodejs
    go
    skim
    bspwm
    ncurses
    strace
    jq
    ripgrep
    lazygit
    btop
    tldr
    helix
    bat
    zellij

    run-vbooxd
    templ

    # Language servers and linters
    zls
    marksman

    nixgl.nixGLIntel
    eww
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

#  xsession.windowManager.bspwm = {
#    enable = true;
#
#    monitors = let range = ["1" "2" "3" "4" "5" "6"]; in {
#      "LVDS-1" = range;
#    };
#
#    rules = {
#      "scrcpy" = {
#          state = "floating";
#      };
#    };
#
#    settings = {
#      border_width = 2;
#      window_gap = 12;
#      split_ratio = 0.52;
#      borderless_monocle = true;
#      gapless_monocle = true;
#      focus_follows_pointer = true;
#      pointer_follows_monitor = true;
#      focused_border_color = "#c4a7e7";
#      active_border_color = "#c4a7e7";
#      normal_border_color = "#1f1d2e";
#      presel_feedback_color = "#9ccfd8";
#    };
#
#    extraConfig = ''
#    pgrep -x sxhkd > /dev/null || sxhkd &
#    '';
#  };
}
