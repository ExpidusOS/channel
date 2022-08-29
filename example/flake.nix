{
  description = "Example ExpidusOS configuration";

  inputs.expidus.url = "path:../";
  inputs.nixpkgs.follows = "expidus/nixpkgs";

  outputs = { self, expidus, nixpkgs, home-manager }@attrs:
    let
      systems = expidus.lib.expidusSystem {
        system = {
          name = "x86_64-linux";
          builds = ["virtual-machine"];
        };
      };
    in
    {
      nixosConfigurations.example = systems.virtual-machine;
    };
}
