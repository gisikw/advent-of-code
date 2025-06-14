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
          # ada = pkgs.mkShell { packages = [ ]; };
          # arturo = pkgs.mkShell { packages = [ ]; };
          bash = pkgs.mkShell { packages = [ pkgs.bash ]; };
          # borgo = pkgs.mkShell { packages = [ ]; };
          c = pkgs.mkShell { packages = [ pkgs.gcc ]; };
          clojure = pkgs.mkShell { packages = [ pkgs.clojure pkgs.openjdk ]; };
          # cobol = pkgs.mkShell { packages = [ ]; };
          crystal = pkgs.mkShell { packages = [ pkgs.crystal ]; };
          # d = pkgs.mkShell { packages = [ ]; };
          dart = pkgs.mkShell { packages = [ pkgs.dart ]; };
          elixir = pkgs.mkShell { packages = [ pkgs.elixir ]; };
          erlang = pkgs.mkShell { packages = [ pkgs.erlang ]; };
          fortran = pkgs.mkShell { packages = [ pkgs.gfortran ]; };
          # fsharp = pkgs.mkShell { packages = [ ]; };
          gleam = pkgs.mkShell { packages = [ pkgs.gleam ]; };
          go = pkgs.mkShell { packages = [ pkgs.go ]; };
          groovy = pkgs.mkShell { packages = [ pkgs.groovy ]; };
          haskell = pkgs.mkShell { packages = [ pkgs.ghc ]; };
          haxe = pkgs.mkShell { packages = [ pkgs.haxe ]; };
          # io = pkgs.mkShell { packages = [ pkgs.io ]; };
          janet = pkgs.mkShell { packages = [ pkgs.janet ]; };
          java = pkgs.mkShell { packages = [ pkgs.openjdk ]; };
          julia = pkgs.mkShell { packages = [ pkgs.julia-bin ]; };
          kotlin = pkgs.mkShell { packages = [ pkgs.kotlin ]; };
          # lobster = pkgs.mkShell { packages = [ ]; };
          # lolcode = pkgs.mkShell { packages = [ ]; };
          lua = pkgs.mkShell { packages = [ pkgs.lua ]; };
          # miniscript = pkgs.mkShell { packages = [ ]; };
          moonscript = pkgs.mkShell { packages = [ pkgs.luajitPackages.moonscript ]; };
          nim = pkgs.mkShell { packages = [ pkgs.nim ]; };
          node = pkgs.mkShell { packages = [ pkgs.nodejs_24 ]; };
          ocaml = pkgs.mkShell { packages = [ pkgs.ocaml ]; };
          odin = pkgs.mkShell { packages = [ pkgs.odin ]; };
          pascal = pkgs.mkShell { packages = [ pkgs.fpc ]; };
          perl = pkgs.mkShell { packages = [ pkgs.perl ]; };
          php = pkgs.mkShell { packages = [ pkgs.php ]; };
          prolog = pkgs.mkShell { packages = [ pkgs.swi-prolog ]; };
          python = pkgs.mkShell { packages = [ pkgs.python314 ]; };
          # qbasic = pkgs.mkShell { packages = [ ]; };
          r = pkgs.mkShell { packages = [ pkgs.R ]; };
          racket = pkgs.mkShell { packages = [ pkgs.racket-minimal ]; };
          # roc = pkgs.mkShell { packages = [ ]; };
          ruby = pkgs.mkShell { packages = [ pkgs.ruby ]; };
          rust = pkgs.mkShell { packages = [ pkgs.rustc ]; };
          # scala = pkgs.mkShell { packages = [ ]; };
          spl = pkgs.mkShell { packages = [ pkgs.spl ]; };
          # sql = pkgs.mkShell { packages = [ ]; };
          # swift = pkgs.mkShell { packages = [ pkgs.scala ]; };
          tcl = pkgs.mkShell { packages = [ pkgs.tcl ]; };
          uiua = pkgs.mkShell { packages = [ pkgs.uiua ]; };
          v = pkgs.mkShell { packages = [ pkgs.vlang ]; };
          # wren = pkgs.mkShell { packages = [ ]; };
          # yasl = pkgs.mkShell { packages = [ ]; };
          zig = pkgs.mkShell { packages = [ pkgs.zig ]; };
        };
      }
    );
}
