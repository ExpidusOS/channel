{ config, stdenv, closureInfo, pkgs, contents, extraCommands, storeContents, branch }:
let
  symlinks = map (x: x.symlink) storeContents;
  objects = map (x: x.object) storeContents;
in
stdenv.mkDerivation {
  name = "flatpak";
  builder = ./make-flatpak.sh;
  nativeBuildInputs = with pkgs; [ ostree ];

  system = builtins.head (builtins.split "-" config.expidus.system.name);

  sources = map (x: x.source) contents;
  targets = map (x: x.target) contents;

  closureInfo = closureInfo {
    rootPaths = objects;
  };

  inherit symlinks objects extraCommands branch;
}
