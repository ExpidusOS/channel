{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.expidus;
  modules = [
  ] ++ optional cfg.system.builds.docker [ ./system/build/docker.nix ];
in modules
