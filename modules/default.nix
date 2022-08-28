{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.expidus;
  # TODO: add modules as we grow
  modules = [
  ] ++ (if cfg.system.builds.docker then [ ./system/build/docker.nix ] else []);
in modules
