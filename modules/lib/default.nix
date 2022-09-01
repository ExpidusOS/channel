{ lib }:
rec {
  trivial = import ./trivial.nix { inherit lib; };
  maintainers = import ./maintainers.nix {};
}
