{ config, lib, pkgs, utils, ... }:
with lib;
let
  cfg = config.expidus;
in
{
  imports = [ ./common.nix ];

  config = mkMerge [
    {
      expidus = {
        extraSpecialArgs.nixosConfig = config;
      };
    }
  ];
}
