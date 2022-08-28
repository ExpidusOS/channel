{
  description = "The easy to use mobile and desktop operating system from Midstall Software";

  inputs.nixpkgs.url = "git+https://github.com/nixOS/nixpkgs?ref=master&rev=ce6aa13369b667ac2542593170993504932eb836";
  inputs.home-manager.url = "git+https://github.com/nix-community/home-manager?ref=release-22.05&rev=4a3d01fb53f52ac83194081272795aa4612c2381";

  outputs = { self }: {
    system = import ./system;
  };
}
