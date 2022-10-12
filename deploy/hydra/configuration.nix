{ config, nixpkgs, ... }:
{
  imports = [
    (nixpkgs + "/nixos/modules/virtualisation/docker-image.nix")
    (nixpkgs + "/nixos/modules/installer/cd-dvd/channel.nix")
  ];

  services.hydra = {
    enabled = true;
    hydraURL = "http://hyra.expidusos.com";
    notificationSender = "hydra@localhost";
    buildMachinesFiles = [];
    useSubstitutes = true;
  };

  documentation.doc.enabled = false;
  system.stateVersion = "22.11";
}
