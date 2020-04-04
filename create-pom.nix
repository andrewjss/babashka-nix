{stdenv, leiningen, src, ...}:
stdenv.mkDerivation rec
{
  name = "babashka-pom";
  inherit src;
  buildInputs = [ leiningen ];
  buildPhase = ''
      HOME=$TMPDIR lein pom
  '';
  installPhase = ''
     mkdir -p $out
     cp pom.xml $out
  '';
}
