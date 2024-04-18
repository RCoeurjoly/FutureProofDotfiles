{
  description = "A flake for my Emacs setup";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, emacs-overlay, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ emacs-overlay.overlay ];
        };
        myEmacs = pkgs.emacsWithPackages (epkgs: with epkgs; [
          # List your packages here
          magit
          org-roam
	  nix-mode
        ]);
      in {
        devShell = pkgs.mkShell {
          buildInputs = [ myEmacs ];
        };
	# Define the application
        apps.emacs = {
          type = "app";
          program = "${myEmacs}/bin/emacs";
        };
	# apps.${system}.default = { type = "app"; program = myEmacs; };
      });
}
