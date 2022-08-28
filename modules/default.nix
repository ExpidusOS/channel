{ config, lib, pkgs, ... }@args:
with lib;
let
  cfg = config.expidus;
  extendedLib = import ./lib/stdlib-extended.nix pkgs.lib;
  os = lib.nixosSystem {
    system = cfg.system.name;
    specialArgs = args // { inherit extendedLib; };
    modules = import ./modules.nix args // { inherit extendedLib; };
  };
in {
  options.expidus = {
    system = {
      name = mkOption {
        type = types.str;
        example = "x86_64-linux";
        description = "Sets the name of the system configuration";
      };
      builds = {
        docker = mkEnableOption ''
          Enable to build a tarball which could be used with Docker
        '';
      };
    };
  };

  nixosConfiguration = os;
}
