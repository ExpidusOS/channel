{
  description = "Example ExpidusOS configuration";

  inputs.expidus.url = "path:../";
  inputs.nixpkgs.follows = "expidus/nixpkgs";

  outputs = { self, expidus, nixpkgs, home-manager }@attrs:
    expidus.lib.expidusSystem {
      system = {
        name = "x86_64-linux";
        builds = {
          virtual-machine = {
            enable = true;
          };
          standard = {
            enable = true;
          };
          docker = {
            enable = true;
          };
        };
      };
    };
}
