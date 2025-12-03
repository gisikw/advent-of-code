{
  description = "Advent of Code multi-language devShells";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    roc.url = "github:roc-lang/roc";
  };

  outputs = { self, nixpkgs, roc, ... }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];

      # Helper to generate attrs for each system
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems f;

      languages = nixpkgs.lib.importTOML ./languages.toml;

    in {
      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
          lib = pkgs.lib;
          customLangs = import ./customLangs.nix { inherit pkgs lib roc system; };

          # Get a package by name, supporting dotted paths like "luajitPackages.moonscript"
          getPkg = name:
            let result = builtins.tryEval (lib.attrByPath (lib.splitString "." name) null pkgs);
            in if result.success then result.value else null;

          # Try to build a shell, catching any errors
          tryMkShell = name: cfg:
            let
              attempt = builtins.tryEval (
                if (cfg.force_x86 or false) && system != "x86_64-linux" then
                  null
                else if cfg.customized or false then
                  let
                    custom = lib.attrByPath [name] {} customLangs;
                    packages = builtins.filter (p: p != null) (map getPkg (cfg.packages or []));
                    extraPkgs = custom.extraPkgs or [];
                    allPackages = packages ++ extraPkgs;
                    expectedLen = builtins.length (cfg.packages or []) + builtins.length extraPkgs;
                  in
                    if custom ? customShell then
                      let drv = custom.customShell;
                      in builtins.seq drv.drvPath drv
                    else if builtins.length allPackages == expectedLen then
                      let drv = pkgs.mkShell { packages = allPackages; };
                      in builtins.seq drv.drvPath drv
                    else
                      null
                else
                  let
                    packages = map getPkg cfg.packages;
                  in
                    if builtins.any (p: p == null) packages then
                      null
                    else
                      let drv = pkgs.mkShell { inherit packages; };
                      in builtins.seq drv.drvPath drv
              );
            in
              if attempt.success && attempt.value != null then
                { inherit name; value = attempt.value; }
              else
                null;

          # Build list of available shells
          shellList = map (name: tryMkShell name languages.${name}) (builtins.attrNames languages);
          validShells = builtins.filter (x: x != null) shellList;
        in builtins.listToAttrs validShells
      );

      langMeta = forAllSystems (system:
        let
          lib = nixpkgs.lib;
        in lib.mapAttrs (_: cfg: {
          run = cfg.run;
          force_x86 = cfg.force_x86 or false;
        }) languages
      );
    };
}
