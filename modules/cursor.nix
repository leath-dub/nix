{ pkgs, ... }:

pkgs.stdenv.mkDerivation {
  pname = "apple_cursor";
  version = "2.0.0";

  src = pkgs.fetchurl {
    url = "https://github.com/ful1e5/apple_cursor/releases/download/v2.0.0/macOS-BigSur-White.tar.gz";
    sha256 = "sha256-vFPXO2zXtk/I38OWv5DIvRu2z8GGblETC7KF6ruGcmE=";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out
    ls
    ${pkgs.busybox}/bin/busybox tar xvf $src
    cp -r * $out
  '';
}
