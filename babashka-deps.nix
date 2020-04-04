{stdenv, curl, maven, pom }:

stdenv.mkDerivation {
  name = "babashka-maven-deps";
  inherit pom;
  buildInputs = [ maven pom curl ];
  builder = ./fetch-babashka-deps.sh;
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "1f919851fmzxmpi3sk5w28b62d0g8w4cvi8y8makarsa4ginzgha";
}
