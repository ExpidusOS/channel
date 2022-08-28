{ config, lib, pkgs, ... }@args:
with lib;
let
  cfg = config.expidus;
  extendedLib = import ../modules/lib/stdlib-extended.nix pkgs.lib;
  os = lib.nixosSystem {
    system = cfg.system.name;
    specialArgs = args // { inherit extendedLib; };
    modules = [ ./modules.nix ];
  };
in {
  options.expidus.name = mkOption {
    type = types.str;
    example = "linux";
    description = ''
      Sets the system hostname
    '';
  };

  options.expidus.system = {
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

  nixosConfigurations.${cfg.name} = mkIf cfg.system.builds.system os;
  packages.${cfg.system.name} = {
    ${cfg.name + "-docker"} = mkIf cfg.system.builds.docker os.config.system.build.tarball;
  };
}
