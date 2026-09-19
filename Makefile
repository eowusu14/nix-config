FLAKE_DIR ?= $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
DARWIN_HOST ?= emmanuel
# sudo resets PATH, so resolve darwin-rebuild from the system profile rather
# than relying on the invoking user's shell PATH.
DARWIN_REBUILD ?= /nix/var/nix/profiles/system/sw/bin/darwin-rebuild

.PHONY: rebuild update update-nix update-homebrew

# Rebuild configures system and installs packages declared in darwin.nix (nixpkgs + homebrew)
rebuild:
	sudo "$(DARWIN_REBUILD)" switch --flake "$(FLAKE_DIR)#$(DARWIN_HOST)" --show-trace

# Update all pinned inputs, then rebuild once.
update:
	nix flake update --flake "$(FLAKE_DIR)"
	sudo "$(DARWIN_REBUILD)" switch --flake "$(FLAKE_DIR)#$(DARWIN_HOST)" --show-trace

# Update Nix-managed packages without changing Homebrew inputs or packages.
update-nix:
	nix flake update nixpkgs nix-darwin home-manager --flake "$(FLAKE_DIR)"
	sudo "$(DARWIN_REBUILD)" switch --flake "$(FLAKE_DIR)#$(DARWIN_HOST)" --show-trace

# Update pinned Homebrew inputs, then apply them without imperative package upgrades.
update-homebrew:
	nix flake update brew-src nix-homebrew homebrew-core homebrew-cask homebrew-bundle --flake "$(FLAKE_DIR)"
	sudo "$(DARWIN_REBUILD)" switch --flake "$(FLAKE_DIR)#$(DARWIN_HOST)" --show-trace
