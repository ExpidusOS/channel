{
  description = "The easy to use mobile and desktop operating system from Midstall Software";

  inputs.flake-utils.url = github:numtide/flake-utils;
  inputs.nixpkgs.url = github:NixOS/nixpkgs;

  inputs.home-manager = {
    url = github:nix-community/home-manager;
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.utils.follows = "flake-utils";
  };

  inputs.libtokyo = {
    url = github:ExpidusOS/libtokyo;
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, home-manager, nixpkgs, libtokyo, ... }@inputs:
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
    in {
      packages = forAllSystems (system: 
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          libtokyo = inputs.libtokyo.packages.${system}.default;
        });

      lib = {
        expidusSystem = { system }@expidus:
          let
            pkgs = nixpkgsFor.${system.name};
            lib = nixpkgs.lib;
            extendedLib = import ./modules/lib/stdlib-extended.nix lib;
            config = { inherit expidus; };

            args = {
              inherit config;
              inherit lib;
              inherit pkgs;
              inherit extendedLib;
            };
          in lib.nixosSystem {
            system = system.name;
            specialArgs = args;
            modules = import ./modules/default.nix args;
          };
      };
    };
}
