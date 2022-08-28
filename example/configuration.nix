{ pkgs, config, lib, expidus, home-manager, ... }:
{
  imports = [
    <nixpkgs/nixos/modules/virtualisation/docker-image.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];

  system.stateVersion = "22.11";
  documentation.doc.enable = false;

  environment.systemPackages = with pkgs; [
    nix
    bashInteractive
  ];
}