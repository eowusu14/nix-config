{ ... }:
{
  home.file.".p10k.zsh".source = ../dotfiles/.p10k.zsh;

  xdg.configFile = {
    aerospace.source = ../dotfiles/aerospace;
    ghostty.source = ../dotfiles/ghostty;
    nvim.source = ../dotfiles/nvim;
    "herdr/config.toml".source = ../dotfiles/herdr/config.toml;
  };
}
