.PHONY: darwin-rebuild

darwin-rebuild:
	sudo darwin-rebuild switch --flake ~/nix#emmanuel --show-trace
