let
  sha256 = "sha256:d981e8fce099954257c1f5071d2c98a16f53f8215b3acbe9d4a46b05cd1c517e";
  rev = "4a3d01fb53f52ac83194081272795aa4612c2381";
in
builtins.trace "(Using pinned Home Manager at ${rev})"
import (fetchTarball {
  url = "https://github.com/nix-community/home-manager/archive/${rev}.tar.gz";
  inherit sha256;
})
