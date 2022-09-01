{ config, expidus, extendedLib, lib, ... }:
with lib;
let
  options = extendedLib.makeOptions { inherit expidus config; };
  config = extendedLib.makeConfig { inherit expidus config; };
  cfg = config.expidus;
in
{
  inherit config options;
}
