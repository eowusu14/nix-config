{ pkgs, ... }:
{
  home.username = if pkgs.stdenv.isDarwin then "owusu.boateng" else "eowusu";
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/owusu.boateng" else "/home/eowusu";
  home.stateVersion = "24.11";

  home.packages = [
    pkgs.tmux
  ];
}
