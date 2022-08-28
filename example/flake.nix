{
  description = "Example ExpidusOS configuration";

  inputs.expidus.url = "path:../";

  outputs = { self, expidus, nixpkgs }: {
    nixosConfigurations.example = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
    };
  };
}
