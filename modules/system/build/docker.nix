{ config, expidus, nixpkgs, extendedLib, ... }:
let
  config = extendedLib.options { inherit expidus config; };
  cfg = config.expidus;
in
{

  imports = [
    (nixpkgs + "/nixos/modules/virtualisation/docker-image.nix")
    (nixpkgs + "/nixos/modules/installer/cd-dvd/channel.nix")
  ];

  documentation.doc.enable = cfg.system.builds.docker;
}
