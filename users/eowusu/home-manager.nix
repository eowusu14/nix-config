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
    ".zshrc".source = ./dotfiles/.zshrc;
    ".p10k.zsh".source = ./dotfiles/.p10k.zsh;
    ".tmux.conf".source = ./dotfiles/.tmux.conf;
  };

  xdg.configFile."aerospace".source = ./dotfiles/aerospace;
  xdg.configFile."ghostty".source = ./dotfiles/ghostty;
  xdg.configFile."nvim".source = ./dotfiles/nvim;
}
