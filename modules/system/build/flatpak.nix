{ config, nixpkgs, extendedLib, pkgs, ... }:
let
  cfg = config.expidus.system.builds.flatpak;
  pkgs2storeContents = l : map (x: { object = x; symlink = "none"; }) l;

  contents = [
    {
      source = "${config.system.build.toplevel}/.";
      target = "./";
    }
  ];

  storeContents = pkgs2storeContents [
    config.system.build.toplevel
    pkgs.stdenv
  ];

  symlinks = map (x: x.symlink) storeContents;
  objects = map (x: x.object) storeContents;
in
{
  imports = [
    (nixpkgs + "/nixos/modules/installer/cd-dvd/channel.nix")
    (nixpkgs + "/nixos/modules/profiles/minimal.nix")
    (nixpkgs + "/nixos/modules/profiles/clone-config.nix")
  ];

  system.build.flatpak = pkgs.stdenv.mkDerivation {
    name = "flatpak";
    builder = ./flatpak.sh;
    nativeBuildInputs = with pkgs; [ ostree ];

    branch = "${cfg.type}/${cfg.id}/${(builtins.head (builtins.split "-" config.expidus.system.name))}";

    sources = map (x: x.source) contents;
    targets = map (x: x.target) contents;

    closureInfo = pkgs.closureInfo {
      rootPaths = objects;
    };

    inherit symlinks objects;
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
