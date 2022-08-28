{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.expidus;
  extendedLib = import ../modules/lib/stdlib-extended.nix pkgs.lib;
  exModule = types.submoduleWith {
    description = "ExpidusOS module";
    specialArgs = {
      lib = extendedLib;
      osConfig = config;
      modulesPath = builtins.toString ../modules;
    } // cfg.extraSpecialArgs;
    modules = [
      ({ name, ... }: {
        imports = import ../modules/modules.nix {
          inherit pkgs;
          lib = extendedLib;
          useNixpkgsModule = !cfg.useGlobalPkgs;
        };
      })
    ];
  };
in {
  options.expidus = {
    useGlobalPkgs = mkEnableOption ''
      using the system configuration's <literal>pkgs</literal>
      argument in ExpidusOS. This disables the Home Manager
      options <option>nixpkgs.*</option>
    '';

    extraSpecialArgs = mkOption {
      type = types.attrs;
      default = { };
      example = literalExpression "{ inherit emacs-overlay; }";
      description = ''
        Extra <literal>specialArgs</literal> passed to ExpidusOS. This
        option can be used to pass additional arguments to all modules.
      '';
    };
  };
}
