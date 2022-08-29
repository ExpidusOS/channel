{
  description = "Example ExpidusOS configuration";

  inputs.expidus.url = "path:../";
  inputs.nixpkgs.follows = "expidus/nixpkgs";

  outputs = { self, expidus, nixpkgs, home-manager }@attrs:
    let
      systems = expidus.lib.expidusSystem {
        system = {
          name = "x86_64-linux";
          builds = ["virtual-machine" "docker"];
        };
      };
    in
    {
      nixosConfigurations.example = systems.virtual-machine;
      packages.x86_64-linux.default = systems.docker.config.system.build.tarball;
    };
}
