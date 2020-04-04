self: super: {
  babashka = self.callPackage ./derivation.nix{};
}
