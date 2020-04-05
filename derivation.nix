{stdenv, callPackage, strace, buildMaven, curl, maven, fetchFromGitHub, leiningen, graalvm8, ... }:
stdenv.mkDerivation rec {
  name = "babashka-${version}";
  version = "2020-04-05";

  src = fetchFromGitHub {
    fetchSubmodules = true;
    owner = "borkdude";
    repo = "babashka";
    rev = "847f872df8b2d69888a5ccc6d0a791b742d3a284";
    sha256 = "0c5jib96v062w8rakf7ik5pchsc2ankf14bl8kxcss55y4c8kwxv";
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
