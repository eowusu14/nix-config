.PHONY: darwin-rebuild

rebuild:
	sudo darwin-rebuild switch --flake ~/nix#emmanuel --show-trace
