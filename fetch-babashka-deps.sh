source $stdenv/setup
header "fetching Babashka maven repo"
cd $TMPDIR
cp $pom/pom.xml .
HOME=$TMPDIR _JAVA_OPTIONS="-Duser.home=$TMPDIR" mvn package dependency:go-offline
cp -a $TMPDIR/.m2/repository $out/

function fetchArtifact {
  repoPath="$1"
  echo "fetching $repoPath"
  mkdir -p $(dirname $out/$repoPath)
  curl --fail --location --insecure --max-redirs 20 "https://repo.maven.apache.org/maven2/$repoPath" --output "$out/$repoPath" ||
  curl --fail --location --insecure --max-redirs 20 "https://clojars.org/repo/$repoPath" --output "$out/$repoPath"
}

fetchArtifact clojure-complete/clojure-complete/0.2.5/clojure-complete-0.2.5.jar
fetchArtifact clojure-complete/clojure-complete/0.2.5/clojure-complete-0.2.5.pom
fetchArtifact nrepl/nrepl/0.6.0/nrepl-0.6.0.pom
fetchArtifact nrepl/nrepl/0.6.0/nrepl-0.6.0.jar
fetchArtifact nrepl/nrepl/0.5.3/nrepl-0.5.3.jar
fetchArtifact nrepl/nrepl/0.5.3/nrepl-0.5.3.jar
