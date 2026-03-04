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
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, ... }:
  let
    mkSystem = import ./lib/mksystem.nix { inherit inputs self; };
  in {
    darwinConfigurations.emmanuel = mkSystem "macbook" {
      system = "aarch64-darwin";
      user = "owusu.boateng";
      profile = "eowusu";
      hostName = "emmanuel";
      darwin = true;
    };

    nixosConfigurations.arch-linux = mkSystem "arch-x86_64" {
      system = "x86_64-linux";
      user = "eowusu";
      hostName = "arch-linux";
    };

    nixosConfigurations.homeserver = mkSystem "homeserver-x86_64" {
      system = "x86_64-linux";
      user = "eowusu";
      hostName = "homeserver";
    };

    homeConfigurations."owusu.boateng" = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs {
        system = "aarch64-darwin";
        config.allowUnfree = true;
      };
      extraSpecialArgs = {
        inherit inputs self;
        user = "owusu.boateng";
        darwin = true;
      };
      modules = [
        (import ./users/eowusu/home-manager.nix {
          inherit inputs;
          user = "owusu.boateng";
          darwin = true;
        })
      ];
    };
  };
}
