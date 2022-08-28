{
  description = "Example ExpidusOS configuration";

  inputs.expidus.url = "path:../";
  inputs.nixpkgs.follows = "expidus/nixpkgs";

  outputs = { self, expidus, nixpkgs, home-manager }@attrs:
    expidus.lib.expidusSystem {
      name = "example";
    };
}
