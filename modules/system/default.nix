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

          specialOptions = {
            docker = {};
            virtual-machine = {};
            standard = {};
            flatpak = {
              id = mkOption {
                default = "com.expidus.Runtime";
                type = with types; str;
                description = "Package ID to use";
              };

              type = mkOption {
                default = "runtime";
                type = with types; str;
                description = "Specifies what kind of package this is.";
              };
            };
          };

          extraOptions = specialOptions.${name};
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
          } // extraOptions;

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
