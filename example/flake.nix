{
  description = "Example ExpidusOS configuration";

  inputs.expidus.url = "path:../";
  inputs.nixpkgs.follows = "expidus/nixpkgs";

  outputs = { self, expidus, nixpkgs, home-manager }@attrs:
    expidus.nixosModules.expidus {
      expidus.name = "example";
    };
}
