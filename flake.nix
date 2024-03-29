{
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    flake-utils.url = github:numtide/flake-utils;
    latex-utils = {
      url = "github:jmmaloney4/latex-utils";
      # url = "git+file:../latex-utils";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };
  outputs = { self, nixpkgs, flake-utils, latex-utils }:
    with flake-utils.lib; eachSystem allSystems (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      texPackages = {
          inherit (pkgs.texlive) beamer xkeyval collectbox;
      };

    in {
      packages.default = latex-utils.lib.${system}.mkLatexPdfDocument {
        name = "elements-of-tropical-geometry";
        src = self;
        inherit texPackages;
      };
    });
}