{ expidus, extendedLib, lib, target, ... }:
with lib;
let
  # TODO: add modules as we grow
  config = extendedLib.makeOptions { inherit expidus; config = {}; };
  cfg = config.expidus;
  modules = [
    ./system/boot/stage-1.nix
    ./system/boot/stage-2.nix
    ./base.nix
    ./version.nix
  ]
    ++ optional (target == "docker") ./system/build/docker.nix
    ++ optional (target == "virtual-machine") ./system/build/virtual-machine.nix;
in modules
