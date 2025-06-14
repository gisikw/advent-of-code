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
          bash = pkgs.mkShell { packages = [ pkgs.bash ]; };
          c = pkgs.mkShell { packages = [ pkgs.gcc ]; };
          clojure = pkgs.mkShell { packages = [ pkgs.clojure pkgs.openjdk ]; };
          crystal = pkgs.mkShell { packages = [ pkgs.crystal ]; };
          dart = pkgs.mkShell { packages = [ pkgs.dart ]; };
          elixir = pkgs.mkShell { packages = [ pkgs.elixir ]; };
          erlang = pkgs.mkShell { packages = [ pkgs.erlang ]; };
          go = pkgs.mkShell { packages = [ pkgs.go ]; };
          kotlin = pkgs.mkShell { packages = [ pkgs.kotlin ]; };
          lua = pkgs.mkShell { packages = [ pkgs.lua ]; };
          nim = pkgs.mkShell { packages = [ pkgs.nim ]; };
          ocaml = pkgs.mkShell { packages = [ pkgs.ocaml ]; };
          perl = pkgs.mkShell { packages = [ pkgs.perl ]; };
          php = pkgs.mkShell { packages = [ pkgs.php ]; };
          ruby = pkgs.mkShell { packages = [ pkgs.ruby ]; };
          tcl = pkgs.mkShell { packages = [ pkgs.tcl ]; };
        };
      }
    );
}
