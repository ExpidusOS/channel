{
  description = "Example ExpidusOS configuration";

  inputs.expidus.url = "path:../";

  outputs = { self, expidus, nixpkgs }@attrs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = attrs;
        modules = [ expidus.configuration ./configuration.nix ];
      };
    in
    {
      nixosConfigurations.example = nixos;
      packages.x86_64-linux.default = nixos.config.system.build.tarball;
    };
}
