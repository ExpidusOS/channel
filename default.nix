{ system ? builtins.currentSystem, platform ? null }:
let
  home-manager = import ./home-manager.nix;
  pkgs = import ./nixpkgs.nix { inherit system; platform = platform; config = {}; };
  pkgsModule = rec {
    _file = ./default.nix;
    key = _file;
    config = {
      nixpkgs.localSystem = { inherit system; };
    };
  };
in
{}
