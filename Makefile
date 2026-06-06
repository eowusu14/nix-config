.PHONY: rebuild update-nix

# Rebuild configures system and installs packages declared in darwin.nix (nixpkgs + homebrew)
rebuild:
	sudo darwin-rebuild switch --flake ~/nix#emmanuel --show-trace

# Update-nix upgrades nix packages to latest version. rebuild does not update nix packages.
update-nix:
	nix flake update --flake ~/nix
	sudo darwin-rebuild switch --flake ~/nix#emmanuel --show-trace
