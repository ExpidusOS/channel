{ config, lib, pkgs, utils, ... }:
with lib;
let
  cfg = config.expidus;
  extendedLib = import ../modules/lib/stdlib-extended.nix pkgs.lib;
in {
  options.expidus.name = mkOption {
    type = types.str;
  };

  imports = import ./modules.nix {
    inherit pkgs;
    lib = extendedLib;
  };
}
