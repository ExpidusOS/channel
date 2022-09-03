{
  description = "The easy to use mobile and desktop operating system from Midstall Software";

  inputs.flake-utils.url = "github:numtide/flake-utils?rev=04c1b180862888302ddfb2e3ad9eaa63afc60cf8";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs?rev=ce6aa13369b667ac2542593170993504932eb836";

  inputs.home-manager = {
    url = "github:nix-community/home-manager?rev=4a3d01fb53f52ac83194081272795aa4612c2381";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.libtokyo = {
    url = github:ExpidusOS/libtokyo;
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, home-manager, nixpkgs, libtokyo, ... }@inputs:
    let
      supportedSystems = builtins.attrNames libtokyo.packages;
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in {
      packages = forAllSystems (system: 
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          libtokyo = inputs.libtokyo.packages.${system}.default;
        });

      lib = {
        expidusSystem = { name ? "expidus", system ? {}, modules ? [] }@expidus:
          let
            ourPkgs = self.packages.${system.name};
            pkgs = nixpkgsFor.${system.name};
            lib = nixpkgs.lib;
            extendedLib = (import ./modules/lib/stdlib-extended.nix lib).ex;
          in rec {
            systems = builtins.mapAttrs (target: config: lib.nixosSystem {
              system = system.name;
              specialArgs = {
                inherit extendedLib nixpkgs target expidus home-manager;
              };
              baseModules = import ./modules/nixos.nix {
                inherit nixpkgs expidus home-manager;
              };
              modules = (import ./modules/default.nix {
                inherit extendedLib lib target home-manager;
              }) ++ modules;
            }) system.builds;

            nixosConfigurations.${name + "-vm"} = if builtins.hasAttr "virtual-machine" systems then systems.virtual-machine else null;
            nixosConfigurations.${name} = if builtins.hasAttr "standard" systems then systems.standard else null;
            packages.${system.name} = {
              ${name + "-docker"} = if builtins.hasAttr "docker" systems then systems.docker.config.system.build.tarball else null;
              ${name + "-flatpak"} = if builtins.hasAttr "flatpak" systems then systems.flatpak.config.system.build.flatpak else null;
            };
          };
      };
    };
}
