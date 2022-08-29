{ lib }:
rec {
  trivial = import ./trivial.nix { inherit lib; };
  maintainers = import ./maintainers.nix {};
  makeOptions = { expidus, config }: (import ./options.nix {
    config = { inherit expidus; };
    inherit lib expidus;
  }).config;
}
