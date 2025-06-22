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

        langs = {
          ada = {
            packages = [ pkgs.gnat ];
            run = "/bin/sh run.sh";
          };
          # arturo = {
          #   packages = [ ];
          #   run = "arturo solution.art";
          # };
          bash = {
            packages = [ pkgs.bash ]; 
            run = "bash solution.sh";
          };
          # borgo = {
          #   packages = [ ];
          #   run = "/bin/sh run.sh";
          # }
          c = {
            packages = [ pkgs.gcc ];
            run = "/bin/sh run.sh";
          };
          clojure = {
            packages = [ pkgs.clojure pkgs.openjdk ];
            run = "clojure -M -i solution.clj -m solution";
          };
          cobol = {
            packages = [ pkgs.gnu-cobol ];
            run = "/bin/sh run.sh";
          };
          crystal = {
            packages = [ pkgs.crystal ];
            run = "crystal run solution.cr --";
          };
          d = {
            packages = [ pkgs.dmd ];
            run = "/bin/sh run.sh";
          };
          dart = {
            packages = [ pkgs.dart ];
            run = "dart solution.dart";
          };
          elixir = {
            packages = [ pkgs.elixir ];
            run = "elixir solution.exs";
          };
          erlang = {
            packages = [ pkgs.erlang ];
            run = "/bin/sh run.sh";
          };
          fortran = {
            packages = [ pkgs.gfortran ];
            run = "/bin/sh run.sh";
          };
          fsharp = {
            packages = [ pkgs.dotnet-sdk_8 ];
            run = "dotnet fsi solution.fsx";
          };
          gleam = {
            packages = [ pkgs.gleam pkgs.erlang ];
            run = "gleam run";
          };
          go = {
            packages = [ pkgs.go ];
            run = "go run solution.go";
          };
          groovy = {
            packages = [ pkgs.groovy ];
            run = "groovy solution.groovy";
          };
          haskell = {
            packages = [ pkgs.ghc ];
            run = "/bin/sh run.sh";
          };
          haxe = {
            packages = [ pkgs.haxe ];
            run = "haxe --run Solution";
          };
          # io = {
          #   packages = [ pkgs.io ];
          #   run = "io solution.io";
          # };
          janet = {
            packages = [ pkgs.janet ];
            run = "janet solution.janet";
          };
          java = {
            packages = [ pkgs.openjdk ];
            run = "/bin/sh run.sh";
          };
          julia = {
            packages = [ pkgs.julia-bin ];
            run = "julia solution.jl";
          };
          kotlin = {
            packages = [ pkgs.kotlin ];
            run = "/bin/sh run.sh";
          };
          # lobster = {
          #   packages = [ ];
          #   run = "lobster solution.lobster --";
          # };
          # lolcode = {
          #   packages = [ pkgs.lolcode ];
          #   run = "/bin/sh run.sh";
          # };
          lua = {
            packages = [ pkgs.lua ];
            run = "lua solution.lua";
          };
          # miniscript = {
          #   packages = [ pkgs.miniscript] ;
          #   run = "miniscript solution.ms";
          # };
          moonscript = {
            packages = [ pkgs.luajitPackages.moonscript ];
            run = "moon solution.moon";
          };
          nim = {
            packages = [ pkgs.nim ];
            run = "/bin/sh run.sh";
          };
          node = {
            packages = [ pkgs.nodejs_24 ];
            run = "node solution.js";
          };
          ocaml = {
            packages = [ pkgs.ocaml ];
            run = "ocaml solution.ml";
          };
          odin = {
            packages = [ pkgs.odin ];
            run = "odin run solution.odin -file --";
          };
          pascal = {
            packages = [ pkgs.fpc ];
            run = "/bin/sh run.sh";
          };
          perl = {
            packages = [ pkgs.perl ];
            run = "perl solution.pl";
          };
          php = {
            packages = [ pkgs.php ];
            run = "php solution.php";
          };
          prolog = {
            packages = [ pkgs.swi-prolog ];
            run = "swipl solution.pl";
          };
          python = {
            packages = [ pkgs.python314 ];
            run = "python solution.py";
          };
          # qbasic = {
          #   packages = [ pkgs.fbc ];
          #   run = "/bin/sh run.sh";
          # };
          r = {
            packages = [ pkgs.R ];
            run = "Rscript solution.R";
          };
          # racket = {
          #   packages = [ pkgs.racket-minimal ];
          #   run = "racket solution.rkt";
          # };
          # roc = {
          #   packages = [ ];
          #   run = "/bin/sh run.sh";
          # }
          ruby = {
            packages = [ pkgs.ruby ];
            run = "ruby solution.rb";
          };
          rust = {
            packages = [ pkgs.rustc pkgs.cargo ];
            run = "cargo run --quiet --bin solution";
          };
          # scala = {
          #   packages = [ pkgs.scala pkgs.sbt pkgs.openjdk ];
          #   run = "/bin/sh run.sh";
          # };
          spl = {
            packages = [
              (pkgs.python311.withPackages (ps: [ ps.pip ]))
            ];
            run = "/bin/sh run.sh";
          };
          # sql = {
          #   packages = [ ];
          #   run = "/bin/sh run.sh";
          # }
          # swift = {
          #   packages = [ pkgs.swift ];
          #   run = "swift solution.swift";
          # };
          tcl = {
            packages = [ pkgs.tcl ];
            run = "tclsh solution.tcl";
          };
          uiua = {
            packages = [ pkgs.uiua ];
            run = "uiua run --no-color solution.ua";
          };
          v = {
            packages = [ pkgs.vlang ];
            run = "v run solution.v";
          };
          # wren = {
          #   packages = [ ];
          #   run = "wren_cli solution.wren";
          # };
          # yasl = {
          #   packages = [ ];
          #   run = "yasl solution.yasl";
          # }
          zig = {
            packages = [ pkgs.zig ];
            run = "/bin/sh run.sh";
          };
        };

        devShells = builtins.mapAttrs (name: cfg:
          pkgs.mkShell {
            inherit (cfg) packages;
          }
        ) langs;

        langMeta = builtins.mapAttrs (_: cfg: {
          platform = cfg.platform or null;
          run = cfg.run;
        }) langs;
      in {
        devShells = devShells;
        packages = { };
        langMeta = langMeta;
      }
    );
}
