{stdenv, callPackage, strace, buildMaven, curl, maven, fetchFromGitHub, leiningen, graalvm8, ... }:
stdenv.mkDerivation rec {
  name = "babashka-${version}";
  version = "2020-04-06";

  src = fetchFromGitHub {
    fetchSubmodules = true;
    owner = "borkdude";
    repo = "babashka";
    rev = "b522531e79cccb75f9d083c61f99af2965f1362d";
    sha256 = "0ly6janp0a7yabxcfwpzvj8p3vhypffzwkl8jndspb2d1s56v1g9";
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
