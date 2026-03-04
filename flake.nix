{
  description = "Emmanuel's multi-host Nix configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-core = { url = "github:homebrew/homebrew-core"; flake = false; };
    homebrew-cask = { url = "github:homebrew/homebrew-cask"; flake = false; };
    homebrew-bundle = { url = "github:homebrew/homebrew-bundle"; flake = false; };

    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = inputs@{ self, ... }:
  let
    mkSystem = import ./lib/mksystem.nix { inherit inputs self; };
  in {
    darwinConfigurations.emmanuel = mkSystem {
      kind = "darwin";
      system = "aarch64-darwin";
      modules = [
        ./machines/darwin/emmanuel.nix
        ./modules/darwin/common.nix
      ];
    };

    nixosConfigurations.arch-linux = mkSystem {
      kind = "nixos";
      system = "x86_64-linux";
      modules = [
        ./machines/linux/arch-linux.nix
        ./modules/linux/common.nix
      ];
    };

    nixosConfigurations.ubuntu-server = mkSystem {
      kind = "nixos";
      system = "x86_64-linux";
      modules = [
        ./machines/linux/ubuntu-server.nix
        ./modules/linux/common.nix
      ];
    };
  };
}
