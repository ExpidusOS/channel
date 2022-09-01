{ config, expidus, nixpkgs, extendedLib, ... }:
let
  options = extendedLib.makeOptions { inherit expidus config; };
  config = extendedLib.makeConfig { inherit expidus config; };
  cfg = config.expidus;
in
{
  inherit config options;

  imports = [
    (nixpkgs + "/nixos/modules/virtualisation/qemu-vm.nix")
    (nixpkgs + "/nixos/modules/installer/scan/not-detected.nix")
    (nixpkgs + "/nixos/modules/profiles/qemu-guest.nix")
  ];
}
