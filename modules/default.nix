{ config, lib, pkgs, ... }@args:
with lib;
let
  cfg = config.expidus;
  extendedLib = import ../modules/lib/stdlib-extended.nix pkgs.lib;
  os = lib.nixosSystem {
    system = cfg.system.name;
    specialArgs = args // { inherit extendedLib; };
    modules = import ./modules.nix args // { inherit extendedLib; };
  };
in {
  options.expidus = {
    name = mkOption {
      type = types.str;
      readOnly = true;
      example = "linux";
      description = ''
        Sets the system hostname
      '';
    };
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
        system = mkEnableOption ''
          Enable to build a standard system
        '';
      };
    };
  };

  nixosConfigurations.${cfg.name} = if cfg.system.builds.system then os else null;
  packages.${cfg.system.name}.${cfg.name + "-docker"} = if cfg.system.builds.docker then os.config.system.build.tarball else null;
}
