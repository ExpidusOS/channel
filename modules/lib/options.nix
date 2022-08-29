{ config, expidus, lib }:
with lib;
let
  cfg = config.expidus;
in
{
  # Option template
  options.expidus = {
    name = mkOption {
      type = types.string;
      default = "expidus";
      description = ''
        Sets the hostname of the system.
      '';
    };
    system = {
      name = mkOption {
        type = types.string;
        default = builtins.currentSystem;
        description = ''
          The system target name to use.
        '';

        builds = mkOption {
          type = types.enum [ "docker" "virtual-machine" "standard" ];
          default = [];
          description = ''
            The system build types to output.
          '';
        };
      };
    };
  };

  # Default options
  config.expidus = {
    name = "expidus";
    system = {
      name = builtins.currentSystem;
      builds = [ "standard" ];
    };
  } // expidus;
}
