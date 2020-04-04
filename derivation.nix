{stdenv, callPackage, strace, buildMaven, curl, maven, fetchFromGitHub, leiningen, graalvm8, ... }:
stdenv.mkDerivation rec {
  name = "babashka-${version}";
  version = "2020-04-04";

  src = fetchFromGitHub {
    fetchSubmodules = true;
    owner = "borkdude";
    repo = "babashka";
    rev = "8b90e40de463eee2ddca752100ecb4dd9b5a23bc";
    sha256 = "10x3k87pism55c0nzcdkm4fc48bw7qzrxla2472b97cf5bfpgrzh";
  };

  pom = callPackage ./create-pom.nix { inherit src leiningen stdenv; };
  mavenRepo = import ./babashka-deps.nix { inherit stdenv curl maven pom; };

  buildInputs = [ strace leiningen graalvm8 ];
  patches = [ ./scripts.patch ];
  buildPhase = ''
    mkdir -p $TMPDIR/.m2
    ln -s $mavenRepo $TMPDIR/.m2/repository
    _JAVA_OPTIONS="-Duser.home=$TMPDIR" GRAALVM_HOME=${graalvm8} HOME=$TMPDIR ./script/compile
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp bb $out/bin/
  '';
}
