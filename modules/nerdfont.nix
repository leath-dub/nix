{ pkgs, ... }:

pkgs.stdenv.mkDerivation {
  pname = "nerdfont";
  version = "1.0.0";

  src = pkgs.fetchurl {
    url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/NerdFontsSymbolsOnly.zip";
    sha256 = "8c64613efe0c5d11664a931d241e756ea422cf4ad18d799f1cb5e43171226a76";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out
    ls
    ${pkgs.busybox}/bin/busybox unzip $src
    cp * $out
  '';
}
