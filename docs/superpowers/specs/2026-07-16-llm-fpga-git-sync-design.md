# LLM-FPGA paper library Git sync design

## Goal

Include the local `LLM-inference-on-FPGA-papers` repository in the managed
Home Manager `git-sync` service.

## Chosen approach

Add one `services.git-sync.repositories` entry in `home.nix`:

- name: `llm-inference-on-fpga-papers`
- path: `${config.home.homeDirectory}/LLM-inference-on-FPGA-papers`
- URI: `git@github.com:RCoeurjoly/LLM-inference-on-FPGA-papers.git`

The existing `git_sync_all` shell helper is intentionally unchanged. The
pre-existing `flake.lock` modification is outside this work and will not be
altered.

## Validation

Evaluate the Home Manager configuration, activate
`homeConfigurations.roland`, then confirm that the managed git-sync setup
contains both the existing Exocortex repository and the new paper library.
