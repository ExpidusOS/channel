{ config, nixpkgs, extendedLib, pkgs, ... }:
let
  cfg = config.expidus;
in
{
  system.build.flatpak = pkgs.stdenv.mkDerivation {
    name = "flatpak";
  };

  boot.isContainer = true;
  boot.postBootCommands =
    ''
      # After booting, register the contents of the Nix store in the Nix
      # database.
      if [ -f /nix-path-registration ]; then
        ${config.nix.package.out}/bin/nix-store --load-db < /nix-path-registration &&
        rm /nix-path-registration
      fi
      # nixos-rebuild also requires a "system" profile
      ${config.nix.package.out}/bin/nix-env -p /nix/var/nix/profiles/system --set /run/current-system
    '';

  system.activationScripts.installInitScript = ''
    ln -fs $systemConfig/init /init
  '';
}
