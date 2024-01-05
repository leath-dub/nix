{ pkgs, ... }:

pkgs.stdenv.mkDerivation {
  pname = "zig";
  version = "0.12.0-dev";

  src = pkgs.fetchurl {
    url = "https://ziglang.org/builds/zig-linux-x86_64-0.12.0-dev.1861+412999621.tar.xz";
    hash = "sha256-D1b7hjiNjoKHG/DYfPJCnHIFPAOE0HCB79yLRAGcl/k=";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out
    ls
    ${pkgs.busybox}/bin/busybox tar xvf $src
    cp -r * $out
  '';
}
