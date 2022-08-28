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
        expidus = (import ./modules/lib/stdlib-extended.nix nixpkgs.lib);
        expidusSystem = { system }@expidus: (import ./modules {
          pkgs = nixpkgsFor.${system};
          lib = nixpkgs.lib;
          config = {
            inherit expidus;
          };
        }).nixosConfiguration;
      };
    };
}
