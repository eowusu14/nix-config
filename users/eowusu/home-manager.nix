{ user, darwin ? false, ... }:
{
  imports = [
    ./home/cli.nix
    ./home/dotfiles.nix
    ./home/shell.nix
    ./home/tmux.nix
    ./home/work.nix
  ];

  home = {
    username = user;
    homeDirectory = if darwin then "/Users/${user}" else "/home/${user}";
    stateVersion = "24.11";
  };

  programs.home-manager.enable = true;
}
