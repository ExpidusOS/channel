{ config, expidus, lib, ... }:
with lib;
let
  cfg = config.expidus.system;
in
{
  options.expidus.system = {
    name = mkOption {
      type = with types; str;
      default = builtins.currentSystem;
      description = "Set the target system";
    };

    builds = mkOption {
      type = with types; attrsOf (submodule [
        ({ config, name, ... }:
        let
          validNames = [ "docker" "virtual-machine" "standard" "flatpak" ];
        in {
          options = {
            enable = mkOption {
              default = false;
              type = with types; bool;
              description = ''
                Enable to build a "${name}" variant
              '';
            };

            name = mkOption {
              type = with types; str;
              description = ''
                Name of the build variant
              '';
            };
          };

          config = mkIf config.enable {
            name = if builtins.elem name validNames then name else (throw "Invalid build name: ${name}");
          };
        })
      ]);
      default = {
        standard = {
          enable = true;
        };
      };
      description = "Configuration for build outputs.";
    };
  };

  config.expidus.system = expidus.system;
}
