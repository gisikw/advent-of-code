{
  description = "Advent of Code multi-language devShells";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        devShells = {
          ruby = pkgs.mkShell { packages = [ pkgs.ruby ]; };
          clojure = pkgs.mkShell { packages = [ pkgs.clojure pkgs.openjdk ]; };
        };
      }
    );
}
