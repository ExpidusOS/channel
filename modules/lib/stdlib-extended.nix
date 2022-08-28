nixpkgsLib:
let mkExLib = import ./.;
in nixpkgsLib.extend (self: super: {
  ex = mkExLib { lib = self; };

  literalExpression = super.literalExpression or super.literalExample;
  literalDocBook = super.literalDocBook or super.literalExample;
})
