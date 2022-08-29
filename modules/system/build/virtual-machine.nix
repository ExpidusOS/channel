{ config, expidus, nixpkgs, extendedLib, ... }:
let
  config = extendedLib.makeOptions { inherit expidus config; };
  cfg = config.expidus;
in
{
  imports = [
    (nixpkgs + "/nixos/modules/virtualisation/qemu-vm.nix")
    (nixpkgs + "/nixos/modules/installer/scan/not-detected.nix")
    (nixpkgs + "/nixos/modules/profiles/qemu-guest.nix")
  ];
}
