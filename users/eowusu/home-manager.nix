{ user, darwin ? false, ... }:
{ pkgs, ... }:
{
  home.username = user;
  home.homeDirectory = if darwin then "/Users/${user}" else "/home/${user}";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  home.packages = [
    pkgs.tmux
  ];

  home.file = {
    ".zshrc" = {
      source = ./dotfiles/.zshrc;
      force = true;
    };
    ".p10k.zsh" = {
      source = ./dotfiles/.p10k.zsh;
      force = true;
    };
    ".tmux.conf" = {
      source = ./dotfiles/.tmux.conf;
      force = true;
    };
  };

  xdg.configFile."aerospace" = {
    source = ./dotfiles/aerospace;
    force = true;
  };
  xdg.configFile."ghostty" = {
    source = ./dotfiles/ghostty;
    force = true;
  };
  xdg.configFile."nvim" = {
    source = ./dotfiles/nvim;
    force = true;
  };
}
