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
          helm
          projectile
          flycheck
          company
          yasnippet
          doom-themes
          org-roam
          doom-modeline
          magit
          org-roam
	        nix-mode
          which-key
          ob-elixir
          # ob-coq
          page-break-lines
          auto-complete
          cl-lib
          org-bullets
        ]);
      in {
        devShells = pkgs.mkShell {
          buildInputs = [ myEmacs ];
        };
	# Define the application
        apps.default = {
          type = "app";
          program = "${myEmacs}/bin/emacs";
          args = [ "--load" "${./.}/init.el" ];
        };
        # appp.${system} = apps.emacs;
      });
}
