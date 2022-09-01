{ config, nixpkgs, lib, ... }:
with lib;
let
  cfg = config.expidus;
in
{
  options.expidus = {
    name = mkOption {
      type = types.str;
      default = "expidus";
      description = ''
        Sets the hostname of the system.
      '';
    };
  };

  config = {
    networking.hostName = cfg.name;
    services.getty.greetingLine = ''<<< Welcome to ExpidusOS ${extendedLib.trivial.version} (\m) - \l >>>'';
    system.stateVersion = "22.11";
    system.activationScripts.nix = mkForce (stringAfter [ "etc" "users" ] ''
      install -m 0755 -d /nix/var/nix/{gcroots,profiles}/per-user

      # Subscribe the root user to the ExpidusOS Channel and NixOS channel
      if [ ! -e "/root/.nix-channels" ]; then
        echo "https://github.com/ExpidusOS/channel/archive/refs/heads/master.tar.gz expidus" > "/root/.nix-channels"
        echo "https://nixos.org/channels/nixos-22.05 nixos" >> "/root/.nix-channels"
      fi
    '');
    documentation.nixos.options.warningsAreErrors = false;
    documentation.enable = false;
    expidus.name = if builtins.hasAttr "name" config then config.name else "expidus";
  };
}
