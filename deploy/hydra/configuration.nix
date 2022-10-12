{ config, nixpkgs, ... }:
{
  imports = [
    (nixpkgs + "/nixos/modules/virtualisation/docker-image.nix")
    (nixpkgs + "/nixos/modules/installer/cd-dvd/channel.nix")
  ];

  documentation.doc.enabled = false;
  system.stateVersion = "22.11";
}
