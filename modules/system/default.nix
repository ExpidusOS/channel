{ config, expidus, lib, target, options, pkgs, home-manager, ... }:
with lib;
let
  cfg = config.expidus.system;

  usersType = with types; attrsOf (submodule [
    ({ config, name, ... }:
    let
      hmType = with types; attrsOf (submoduleWith {
        description = "Home Manager module";
        specialArgs = {
          lib = import (home-manager + "/modules/lib/stdlib-extended.nix") pkgs.lib;
          osConfig = config;
          modulesPath = builtins.toString home-manager;
        };
        modules = [
          ({ name, ... }: {
            imports = import (home-manager + "/modules/modules.nix") {
              inherit pkgs;
              lib = import (home-manager + "/modules/lib/stdlib-extended.nix") pkgs.lib;
              useNixpkgsModule = true;
            };

            config = {
              submoduleSupport.enable = true;
              submoduleSupport.externalPackageInstall = true;

              home.username = config.users.users.${name}.name;
              home.homeDirectory = config.users.users.${name}.home;

              home.extraActivationPath = [ config.nix.package ];
            };
          })
        ];
      });

      nix = builtins.map (mod: builtins.map (val: val {
        inherit name;
        config = config.nix;
      }) mod.imports) options.users.users.type.getSubModules;

      home-manager = builtins.map (mod: builtins.map (val: val {
        inherit name;
        config = config.home-manager;
      }) mod.inputs) hmType.getSubModules; 
    in
      {
      options = {
        name = mkOption {
          type = with types; str;
          description = ''
            Name of the user.
          '';
        };

        nix = nix.options;
        home-manager = home-manager.options;
      };

      config = {
        inherit name;
        nix = nix.config;
        home-manager = home-manager.config;
      };
    })
  ]);
in
{
  options.expidus.system = {
    name = mkOption {
      type = with types; str;
      default = builtins.currentSystem;
      description = "Set the target system";
    };

    packages = mkOption {
      type = with types; listOf package;
      default = [];
      example = literalExpression "[ pkgs.firefox pkgs.thunderbird ]";
      description = ''
        Packages to install for all system builds.
      '';
    };

    users = mkOption {
      type = usersType;
      default = {};
      description = ''
        Users to add for all system builds.
      '';
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
              branch = mkOption {
                default = "runtime/com.expidus.Runtime/${builtins.head (builtins.split "-" cfg.name)}/stable";
                type = with types; str;
                description = "The Flatpak package identifier to use";
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

            packages = mkOption {
              type = with types; listOf package;
              default = [];
              example = literalExpression "[ pkgs.firefox pkgs.thunderbird ]";
              description = ''
                Packages to install for this particular system.
              '';
            };

            users = mkOption {
              type = usersType;
              default = {};
              description = ''
                Users to add for this particular system.
              '';
            };

            inherit extraOptions;
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

  config.environment.systemPackages = cfg.packages ++ cfg.builds.${target}.packages;
  config.users.users =
    let
      userDefs = cfg.users // cfg.builds.${target}.users;
    in builtins.mapAttrs (user: user.nix) userDefs;

  imports = [
    home-manager.nixosModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users =
        let
          userDefs = cfg.users // cfg.builds.${target}.users;
        in builtins.mapAttrs (user: user.home-manager) userDefs;
    }
  ];
}
