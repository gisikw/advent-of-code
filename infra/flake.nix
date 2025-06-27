{
  description = "Advent of Code multi-language devShells";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    roc.url = "github:roc-lang/roc";
  };

  outputs = { self, nixpkgs, roc, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      lib = pkgs.lib;
      
      languages = lib.importTOML ./languages.toml;
      customLangs = import ./customLangs.nix { inherit pkgs lib roc system; };

    in {
      devShells.${system} = lib.mapAttrs (name: cfg:
        if cfg.customized or false then
          let custom = lib.attrByPath [name] {} customLangs;
          in if custom ? customShell then
            custom.customShell
          else
            pkgs.mkShell {
              packages = (map (pkg: pkgs.${pkg}) (cfg.packages or [])) ++ (custom.extraPkgs or []);
            }
        else
          pkgs.mkShell { 
            packages = map (pkg: pkgs.${pkg}) cfg.packages;
          }
      ) languages;

      langMeta.${system} = lib.mapAttrs (_: cfg: {
        run = cfg.run;
      }) languages;
    };
}
