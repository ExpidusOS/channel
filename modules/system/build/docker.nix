{ config, nixpkgs, extendedLib, ... }:
let
  cfg = config.expidus;
in
{
  imports = [
    (nixpkgs + "/nixos/modules/virtualisation/docker-image.nix")
    (nixpkgs + "/nixos/modules/installer/cd-dvd/channel.nix")
  ];

  config.documentation.doc.enable = true;
}
