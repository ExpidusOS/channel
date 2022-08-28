{ config, expidus, lib }:
with lib;
let
  cfg = config.expidus;
in
{
  options.expidus = {
    system = {
      name = mkOption {
        type = types.string;
        default = builtins.currentSystem;
        description = ''
          The system target name to use.
        '';

        builds = {
          docker = mkOption {
            type = types.bool;
            default = false;
            description = ''
              Enable to add Docker output
            '';
          };
          virtual-machine = mkOption {
            type = types.bool;
            default = false;
            description = ''
              Enable to add VM output
            '';
          };
        };
      };
    };
  };

  config.expidus = expidus;
}
