{
  outputs = { self, nixpkgs }:
    let
      buildSystems = [
        "aarch64-linux"
        "i686-linux"
        "riscv64-linux"
        "x86_64-linux"
        "x86_64-darwin"
      ];

      targetSystems = [
        "aarch64-linux"
        "i686-linux"
        "riscv64-linux"
        "x86_64-linux"
      ];

      forAllBuildSystems = nixpkgs.lib.genAttrs buildSystems;
      forAllTargetSystems = nixpkgs.lib.genAttrs targetSystems;

      nixpkgsBuildFor = forAllBuildSystems (system: import nixpkgs { inherit system; });
      nixpkgsTargetFor = forAllTargetSystems (system: import nixpkgs { inherit system; });
    in
    {
      packages = forAllBuildSystems (buildSystem:
        forAllTargetSystems (targetSystem:
          (nixpkgs.lib.nixosSystem {
            system = targetSystem;
            modules = [ ./configuration.nix ];
          }).config.system.build.tarball));
    };
}
