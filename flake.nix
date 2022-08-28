{
  description = "The easy to use mobile and desktop operating system from Midstall Software";

  inputs.nixpkgs.url = github:NixOS/nixpkgs;
  inputs.home-manager.url = github:nix-community/home-manager;
  inputs.flake-utils.url = github:numtide/flake-utils;
  inputs.libtokyo.url = github:ExpidusOS/libtokyo;

  outputs = { self, home-manager, nixpkgs, libtokyo, ... }:
    let
      supportedSystems = [
        "aarch64-linux"
        "aarch64-darwin"
        "i686-linux"
        "riscv64-linux"
        "x86_64-linux"
        "x86_64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in
    {
      packages = forAllSystems (system: 
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          libtokyo = libtokyo.packages.${system}.default;
        });

        nixosModules.expidus = {
          configuration = ./configuration.nix;
        };
    };
}
