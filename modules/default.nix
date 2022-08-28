{ config, lib, pkgs, ... }@args:
with lib;
let
  cfg = config.expidus;
  extendedLib = import ../modules/lib/stdlib-extended.nix pkgs.lib;
  os = lib.nixosSystem {
    system = cfg.system.name;
    specialArgs = args;
    modules = [ ./system/default.nix ]
      ++ optional cfg.system.builds.tarball [ <nixpkgs/nixos/modules/virtualisation/docker-image.nix> ];
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
      tarball = mkEnableOption ''
        Enable to build a tarball which could be used with Docker
      '';

      system = mkEnableOption ''
        Enable to build a standard system
      '';
    };
  };

  imports = import ./modules.nix {
    inherit pkgs;
    lib = extendedLib;
  };

  nixosConfiguration.${cfg.name} = mkIf cfg.builds.system os;
  packages.${cfg.system.name}.${cfg.name + "tarball"} = mkIf cfg.builds.tarball os.config.system.build.tarball;
}
