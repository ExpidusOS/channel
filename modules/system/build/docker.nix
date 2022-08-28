{ config, nixpkgs, ... }:
{
  imports = [
    (nixpkgs + "/nixos/modules/virtualisation/docker-image.nix")
    (nixpkgs + "/nixos/modules/installer/cd-dvd/channel.nix")
  ];

  documentation.doc.enable = false;
}
