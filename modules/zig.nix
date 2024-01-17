{ pkgs, ... }:

pkgs.stdenv.mkDerivation {
  pname = "zig";
  version = "0.12.0-dev";

  src = pkgs.fetchurl {
    url = "https://ziglang.org/download/0.11.0/zig-linux-x86_64-0.11.0.tar.xz";
    hash = "sha256-LQDnif7E9xeQpue/g/+R1WSUPF7oQ8X9lm78R0tCMEc=";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out
    ls
    ${pkgs.busybox}/bin/busybox tar xvf $src
    cp -r * $out
  '';
}
