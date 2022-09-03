{ config, stdenv, closureInfo, pkgs, contents, extraCommands, storeContents, type, id }:
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

  closureInfo = pkgs.closureInfo {
    rootPaths = objects;
  };

  inherit symlinks objects extraCommands type id;
}
