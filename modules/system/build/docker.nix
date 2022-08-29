{ config, expidus, nixpkgs, extendedLib, ... }:
let
  config = extendedLib.makeOptions { inherit expidus config; };
  cfg = config.expidus;
in
{
  imports = [
    (nixpkgs + "/nixos/modules/virtualisation/docker-image.nix")
    (nixpkgs + "/nixos/modules/installer/cd-dvd/channel.nix")
  ];

  config.documentation.doc.enable = true;
}
