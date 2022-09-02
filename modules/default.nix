{ extendedLib, lib, target, ... }:
with lib;
let
  # TODO: add modules as we grow
  modules = [
    ./system/activation/top-level.nix
    ./system/boot/stage-1.nix
    ./system/boot/stage-2.nix
    ./system/default.nix
    ./base.nix
    ./version.nix
  ]
    ++ optional (target == "docker") ./system/build/docker.nix
    ++ optional (target == "flatpak") ./system/build/flatpak.nix
    ++ optional (target == "virtual-machine") ./system/build/virtual-machine.nix;
in modules
