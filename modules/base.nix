{ config, expidus, nixpkgs, extendedLib, lib, ... }:
with lib;
let
  config = extendedLib.makeOptions { inherit expidus config; };
  cfg = config.expidus;
in
{
  config = {
    networking.hostName = cfg.name;
    services.getty.greetingLine = ''<<< Welcome to ExpidusOS ${extendedLib.trivial.release} (\m) - \l >>>'';
    system.stateVersion = "22.11";
    documentation.nixos.options.warningsAreErrors = false;
    documentation.enable = false;
  };
}
