{
  description = "Example ExpidusOS configuration";

  inputs.expidus.url = "path:../";
  inputs.nixpkgs.follows = "expidus/nixpkgs";

  outputs = { self, expidus, nixpkgs, home-manager }@attrs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = attrs;
        modules = [
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
          expidus.nixosModules.expidus {}
          ./configuration.nix
        ];
      };
    in
    {
      nixosConfigurations.example = nixos;
      packages.x86_64-linux.default = nixos.config.system.build.tarball;
      expidusConfig = expidus.lib.expidusConfiguration {};
    };
}
