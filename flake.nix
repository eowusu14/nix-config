{
  description = "Emmanuel's macOS Nix configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    brew-src = { url = "github:Homebrew/brew"; flake = false; };
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    nix-homebrew.inputs.brew-src.follows = "brew-src";
    homebrew-core = { url = "github:homebrew/homebrew-core"; flake = false; };
    homebrew-cask = { url = "github:homebrew/homebrew-cask"; flake = false; };
    homebrew-bundle = { url = "github:homebrew/homebrew-bundle"; flake = false; };

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, ... }:
  let
    mkSystem = import ./lib/mksystem.nix { inherit inputs self; };
    darwinHosts = {
      emmanuel = {
        machine = "macbook";
        system = "aarch64-darwin";
        user = "owusu.boateng"; #as shown in home path
        profile = "eowusu";
      };
    };
  in {
    darwinConfigurations = nixpkgs.lib.mapAttrs
      (hostName: host: mkSystem host.machine {
        inherit (host) system user profile;
        inherit hostName;
        darwin = true;
      })
      darwinHosts;

  };
}
