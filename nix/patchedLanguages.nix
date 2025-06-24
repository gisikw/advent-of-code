{ pkgs, lib, ... }:

{
  arturo = pkgs.stdenv.mkDerivation {
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
  };

  borgo = let
    src = pkgs.fetchFromGitHub {
      owner = "borgo-lang";
      repo = "borgo";
      rev = "3b9f01578941fb00ed93756e2fadc009feb50128";
      sha256 = "sha256-KFBMu+uJbIxHWk2Q8wWMbuZ+oA+0mGzmywONWtqiMW4=";
    };
  in pkgs.rustPlatform.buildRustPackage {
    pname = "borgo";
    version = "unstable-2024-06-23";

    inherit src;

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
  };
};
