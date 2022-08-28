{ lib }:
rec {
  maintainers = import ./maintainers.nix;
  options = { expidus, config }: (import ./options.nix {
    config = { inherit expidus; };
    inherit lib expidus;
  }).config
}
