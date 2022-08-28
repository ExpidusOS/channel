{
  description = "Example ExpidusOS configuration";

  inputs.expidus.url = "path:../";
  inputs.nixpkgs.follows = "expidus/nixpkgs";

  outputs = { self, expidus, nixpkgs, home-manager }@attrs:
    let
      system = expidus.lib.expidusSystem {
        system = {
          name = "x86_64-linux";
          builds = {
            docker = true;
            virtual-machine = true;
          };
        };
      };
    in
    {
      nixosConfigurations.example = system;
      packages.x86_64-linux.example-docker = system.config.system.build.tarball;
    };
}
