{
  description = "The easy to use mobile and desktop operating system from Midstall Software";

  inputs.nixpkgs.url = github:NixOS/nixpkgs;
  inputs.home-manager.url = github:nix-community/home-manager;

  outputs = { self, home-manager, nixpkgs }: {
    nixosModule = import ./module.nix;
  };
}
