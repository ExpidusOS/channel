{
  description = "Example ExpidusOS configuration";

  inputs.expidus.url = "path:../";

  outputs = { self, expidus, nixpkgs }@attrs: {
    nixosConfigurations.example = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [ expidus.module ];
    };
  };
}
