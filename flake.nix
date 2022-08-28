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
      supportedSystems = builtins.attrNames libtokyo.packages;
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
            ourPkgs = self.packages.${system.name};
            pkgs = nixpkgsFor.${system.name};
            lib = nixpkgs.lib;
            extendedLib = import ./modules/lib/stdlib-extended.nix lib;
          in lib.nixosSystem {
            system = system.name;
            specialArgs = {
              inherit extendedLib;
              inherit expidus;
              inherit nixpkgs;
            };
            modules = import ./modules/default.nix {
              inherit expidus;
            };
          };
      };
    };
}
