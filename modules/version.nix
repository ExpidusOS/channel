{ config, expidus, nixpkgs, extendedLib, lib, pkgs, target, ... }:
with lib;
let
  cfg = config.expidus;
  trivial = extendedLib.trivial;

  inherit (lib)
    concatStringsSep mapAttrsToList toLower mkForce
    literalExpression mkRenamedOptionModule mkDefault mkOption types;

  needsEscaping = s: null != builtins.match "[a-zA-Z0-9]+" s;
  escapeIfNeccessary = s: if needsEscaping s then s else ''"${lib.escape [ "\$" "\"" "\\" "\`" ] s}"'';
  attrsToText = attrs:
    concatStringsSep "\n" (
      mapAttrsToList (n: v: ''${n}=${escapeIfNeccessary (toString v)}'') attrs
    ) + "\n";

  osReleaseContents = {
    NAME = "ExpidusOS";
    ID = "expidus";
    ID_LIKE = "nixos";
    VERSION = "${trivial.release} (${trivial.codeName})";
    VERSION_CODENAME = toLower trivial.codeName;
    VERSION_ID = trivial.release;
    BUILD_ID = "${trivial.version}-${target}";
    PRETTY_NAME = "ExpidusOS ${trivial.codeName} ${trivial.release}";
    HOME_URL = "https://expidusos.com";
    DOCUMENTATION_URL = "https://expidusos.com";
    SUPPORT_URL = "https://expidusos.com";
    BUG_REPORT_URL = "https://github.com/ExpidusOS/channel/issues";
    VARIANT_ID = target;
  };

  initrdReleaseContents = osReleaseContents // {
    PRETTY_NAME = "${osReleaseContents.PRETTY_NAME} (Initrd)";
  };
  initrdRelease = pkgs.writeText "initrd-release" (attrsToText initrdReleaseContents);

  makeProg = args: pkgs.substituteAll (args // {
    dir = "bin";
    isExecutable = true;
  });

  expidus-version = makeProg {
    name = "expidus-version";
    src = ./expidus-version.sh;
    inherit (pkgs) runtimeShell;
    inherit (extendedLib.trivial) version codeName release revision;
    json = builtins.toJSON ({
      expidusVersion = trivial.version;
    } // optionalAttrs (trivial.revision != "unknown") {
      expidusRevision = trivial.revision;
    });
  };
in
{
  config = {
    environment.etc = {
      "lsb-release".text = mkForce (attrsToText {
        LSB_VERSION = "${trivial.release} (${trivial.codeName})";
        DISTRIB_ID = "expidus";
        DISTRIB_RELEASE = trivial.release;
        DISTRIB_CODENAME = toLower trivial.codeName;
        DISTRIB_DESCRIPTION = "ExpidusOS ${trivial.codeName} ${trivial.release}";
      });
      "os-release".text = mkForce (attrsToText osReleaseContents);
    };

    environment.systemPackages = [ expidus-version ];
  };
}
