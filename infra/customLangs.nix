{ pkgs, lib, roc, system }:

let
  isLinux = builtins.match ".*-linux" system != null;
  isX86Linux = system == "x86_64-linux";
in
{
  # arturo only available as x86_64-linux binary
  arturo = if isX86Linux then {
    extraPkgs = [
      (pkgs.stdenv.mkDerivation {
        pname = "arturo";
        version = "0.9.83";

        src = pkgs.fetchurl {
          url = "https://github.com/arturo-lang/arturo/releases/download/v0.9.83/arturo-0.9.83-full-x86_64-linux.tar.gz";
          sha256 = "sha256-cPxt673C53spHIosqv1iY7sp98YVlFIqGy2nXALFI2I=";
        };

        nativeBuildInputs = [
          pkgs.autoPatchelfHook
          pkgs.makeWrapper
        ];
        buildInputs = [
          pkgs.mpfr
          pkgs.gmp
          pkgs.pcre
          pkgs.gtk3
          pkgs.webkitgtk
          pkgs.stdenv.cc.cc.lib
          pkgs.xorg.libxcb
        ];

        sourceRoot = "source";

        unpackPhase = ''
          mkdir source
          tar -xzf $src -C source
        '';

        installPhase = ''
          install -Dm755 arturo $out/libexec/arturo
          makeWrapper $out/libexec/arturo $out/bin/arturo \
            --set LD_LIBRARY_PATH ${pkgs.lib.makeLibraryPath [
              pkgs.pcre pkgs.gmp pkgs.mpfr pkgs.openssl
            ]}
        '';
      })
    ];
  } else {};

  borgo = {
    extraPkgs = [
      (pkgs.rustPlatform.buildRustPackage rec {
        pname = "borgo";
        version = "unstable-2024-06-23";

        src = pkgs.fetchFromGitHub {
          owner = "borgo-lang";
          repo = "borgo";
          rev = "3b9f01578941fb00ed93756e2fadc009feb50128";
          sha256 = "sha256-KFBMu+uJbIxHWk2Q8wWMbuZ+oA+0mGzmywONWtqiMW4=";
        };

        cargoLock.lockFile = "${src}/Cargo.lock";

        patchPhase = ''
          substituteInPlace compiler/src/fs.rs \
            --replace 'Path::new(env!("CARGO_MANIFEST_DIR"))' \
                      'Path::new("${placeholder "out"}/share/borgo/manifest")'
        '';

        cargoBuildFlags = [ "--package" "compiler" ];

        postInstall = ''
          mkdir -p $out/share/borgo
          cp -r $src/std $out/share/borgo/std
        '';

        doCheck = false;
      })
    ];
  };

  # io uses glibc-specific features, linux only
  io = if isLinux then {
    extraPkgs = [
      (pkgs.stdenv.mkDerivation rec {
        pname = "io";
        version = "2017-09-16";

        glibc_no_ifunc = pkgs.glibc.overrideAttrs (old: {
          pname = "glibc-no-ifunc";
          configureFlags = (old.configureFlags or []) ++ [
            "--disable-multi-arch"
          ];
        });

        src = pkgs.fetchFromGitHub {
          owner = "IoLanguage";
          repo = "io";
          rev = "b8a18fc199758ed09cd2f199a9bc821f6821072a";
          sha256 = "sha256-Qwh8qYxANy3yO7F4sDTSQSm11uEkVBbChc9E8/MPLx8=";
        };

        buildInputs = [ pkgs.python3 glibc_no_ifunc ];
        nativeBuildInputs = [ pkgs.cmake ];

        configurePhase = ''
          export CFLAGS="-D__GLIBC__"
          export NIX_LDFLAGS="-L${glibc_no_ifunc.out}/lib"
          cmake . -DCMAKE_INSTALL_PREFIX=$out
        '';

        patchPhase = ''
          echo '#include <ucontext.h>' | cat - libs/coroutine/source/Coro.c > temp && mv temp libs/coroutine/source/Coro.c

          substituteInPlace libs/iovm/source/IoSystem.c \
            --replace '# include <sys/sysctl.h>' '// removed deprecated sysctl.h'

          echo '#include "hmac.h"' | cat - addons/SHA1/source/IoSHA1.h > temp && mv temp addons/SHA1/source/IoSHA1.h
        '';

        fixupPhase = ''
          find $out -type f -name '*.so' | while read f; do
            if file "$f" | grep -q ELF; then
              patchelf --set-rpath "$out/lib" "$f" || true
            fi
          done
        '';
      })
    ];
  } else {};

  lolcode = {
    extraPkgs = [
      (pkgs.stdenv.mkDerivation rec {
        pname = "lolcode";
        version = "1.4";

        src = pkgs.fetchFromGitHub {
          owner = "justinmeza";
          repo = "lci";
          rev = "327f001df0005ca4f48eb88c58b67c88add46dfd";
          sha256 = "sha256-wQw2mfcma9NKf9NlWJGWII+DxrnmDXBOm0z3aDq2VFs=";
        };

        nativeBuildInputs = [ pkgs.cmake ];
        buildInputs = [ pkgs.python3 pkgs.readline ];
      })
    ];
  };

  miniscript = {
    extraPkgs = [
      (pkgs.stdenv.mkDerivation {
        pname = "miniscript";
        version = "v1.6.2";

        src = pkgs.fetchFromGitHub {
          owner = "JoeStrout";
          repo = "miniscript";
          rev = "v1.6.2";
          sha256 = "sha256-uD3+Nj33mXScp5Pbzo0Rhd6XesaDvXr/8vZi+vetVd4=";
        };

        nativeBuildInputs = [ pkgs.cmake ];
      })
    ];
  };

  roc = {
    extraPkgs = [
      roc.packages.${system}.default
    ];
  };

  shakespeare = {
    extraPkgs = [
      (let
        python = pkgs.python311;
        tatsu = python.pkgs.buildPythonPackage {
          pname = "TatSu";
          version = "5.6.1";
          format = "wheel";
          src = pkgs.fetchurl {
            url = "https://files.pythonhosted.org/packages/54/07/1a48c6d8a177bd16630fe32c856ac4fc29122d5a56b1b374f6e961b189a1/TatSu-5.6.1-py2.py3-none-any.whl";
            sha256 = "sha256-fPA+FasXD9kUibhVzYpJQrbNGsXg6ry4Unk6cWYA2/A=";
          };
          doCheck = false;
        };
        click = python.pkgs.buildPythonPackage {
          pname = "click";
          version = "7.1.2";
          format = "wheel";
          src = pkgs.fetchurl {
            url = "https://files.pythonhosted.org/packages/d2/3d/fa76db83bf75c4f8d338c2fd15c8d33fdd7ad23a9b5e57eb6c5de26b430e/click-7.1.2-py2.py3-none-any.whl";
            sha256 = "sha256-2syon0v63V3j10ibfIpWbu4NNnYzP7tQAwJjiUw4wNw=";
          };
          doCheck = false;
        };
        shakespearelang = python.pkgs.buildPythonPackage {
          pname = "shakespearelang";
          version = "1.0.0";
          format = "wheel";
          src = pkgs.fetchurl {
            url = "https://files.pythonhosted.org/packages/77/7d/70582155d49e01825726ce64e8014221d011ee130b0a37d823cbcadb1c98/shakespearelang-1.0.0-py3-none-any.whl";
            sha256 = "sha256-u6jkM/enAUd0KorENJS0Bz3sYOXy0K86rIf6TexrvAI=";
          };
          propagatedBuildInputs = [ tatsu click ];
          doCheck = false;
        };
      in python.withPackages (ps: [ shakespearelang ]))
    ];
  };

  # swift with Dispatch/Foundation is linux-only in nixpkgs
  swift = if isLinux then {
    customShell = pkgs.mkShell.override { inherit (pkgs.swift) stdenv; } {
      buildInputs = [
        pkgs.swift
        pkgs.swiftPackages.Foundation
        pkgs.swiftPackages.Dispatch
      ];
      shellHook = ''
        export LD_LIBRARY_PATH="${pkgs.swiftPackages.Dispatch}/lib"
      '';
    };
  } else {};

  yasl = {
    extraPkgs = [
      (pkgs.stdenv.mkDerivation {
        pname = "yasl";
        version = "0.13.7";

        src = pkgs.fetchzip {
          url = "https://github.com/yasl-lang/yasl/archive/refs/tags/v0.13.7.zip";
          sha256 = "sha256-w9o+5hpcGzZ0pO5zWwBFNuZ/xR0I4oK8a/Z94e75qno=";
        };

        nativeBuildInputs = [ pkgs.cmake ];

        preConfigure = ''
          find . -name CMakeLists.txt -exec sed -i \
            -e 's/-Werror//g' \
            -e 's/-Wno-pedantic-ms-format//g' \
            -e 's/-Wno-logical-op-parentheses//g' \
            -e 's/-Wno=vla//g' \
            -e 's/-Wno-vla//g' \
            -e 's/=vla//g' {} +
        '';

        installPhase = ''
          mkdir -p $out/bin
          install -Dm755 yasl $out/bin/yasl
        '';
      })
    ];
  };

  smalltalk = {
    extraPkgs = [
      (pkgs.gnu-smalltalk.overrideAttrs (old: {
        postPatch = (old.postPatch or "") + ''
          # Fix iconv const pointer incompatibility with newer glibc
          substituteInPlace packages/iconv/iconv.c \
            --replace "const char *inbuf;" "char *inbuf;"

          # Fix expat SkippedEntityHandler signature (added is_parameter_entity arg in expat 2.3.0)
          substituteInPlace packages/xml/expat/expat.c \
            --replace \
              "gst_SkippedEntityHandler (void *userData,
			  const XML_Char * entityName)" \
              "gst_SkippedEntityHandler (void *userData,
			  const XML_Char * entityName,
			  int is_parameter_entity)"
        '';
      }))
    ];
  };

  wren = {
    extraPkgs = [
      (pkgs.stdenv.mkDerivation {
        pname = "wren-cli";
        version = "0.4.0";

        src = pkgs.fetchFromGitHub {
          owner = "wren-lang";
          repo = "wren-cli";
          rev = "0.4.0";
          sha256 = "sha256-AUb17rV07r00SpcXAOb9PY8Ea2nxtgdZzHZdzfX5pOA=";
        };

        patchPhase = ''
          substituteInPlace src/cli/vm.c --replace "static void write(" "static void wren_write("
          substituteInPlace src/cli/vm.c --replace "config.writeFn = write" "config.writeFn = wren_write"
        '';

        buildPhase = ''
          make -C projects/make
        '';

        installPhase = ''
          mkdir -p $out/bin
          install -Dm755 ./bin/wren_cli $out/bin/wren_cli
        '';
      })
    ];
  };
}
