{ user, darwin ? false, ... }:
{ config, lib, pkgs, ... }:
{
  home.username = user;
  home.homeDirectory = if darwin then "/Users/${user}" else "/home/${user}";
  home.stateVersion = "24.11";

  home.sessionVariables = {
    GOPATH = "$HOME/go";
  };
  home.sessionPath = [
    "$HOME/go/bin"
    "$HOME/.local/bin"
  ];

  programs.home-manager.enable = true;
  home.packages = [
    pkgs.zsh-powerlevel10k
    pkgs.zsh-autosuggestions
    pkgs.zsh-syntax-highlighting
    pkgs.chruby
    pkgs.uv
    pkgs.yt-dlp
  ];

  programs.gpg.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.diff-so-fancy = {
     enable = true;
     enableGitIntegration = true;
   };

   programs.htop = {
     enable = true;
     settings.show_program_path = true;
   };

  programs.lf.enable = true;

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    icons = "always";
    git = true;
    extraOptions = [
         "--group-directories-first"
         "--header"
         "--color=auto"
       ];
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    tmux.enableShellIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.tmux = {
      enable = true;
      keyMode = "vi";
      clock24 = true;
      historyLimit = 9999999;
      mouse = true;
      baseIndex = 1;
      escapeTime = 0;
      plugins = with pkgs.tmuxPlugins; [
        tokyo-night-tmux
        resurrect
        continuum
        vim-tmux-navigator
        sensible
      ];
      extraConfig = ''
        # reload config file
        bind r source-file ~/.config/tmux/tmux.conf \; display-message "~/.config/tmux/tmux.conf reloaded."

        set -g default-terminal "tmux-256color"
        setw -g xterm-keys on
        set -g default-shell "/bin/zsh"

        #start panes at 1
        set -g pane-base-index 1

        # start windows at 1 too
        set -g base-index 1

        # remap prefix from 'C-b' to 'C-a'
        unbind C-b
        set-option -g prefix C-a
        bind-key C-a send-prefix

        # split panes using | and -
        bind | split-window -h
        bind - split-window -v
        unbind '"'
        unbind %

        # switch panes using Ctrl+Shift+arrow without prefix
        bind -n C-S-Left select-pane -L
        bind -n C-S-Right select-pane -R
        bind -n C-S-Up select-pane -U
        bind -n C-S-Down select-pane -D

        # switch panes vim-like
        bind-key h select-pane -L
        bind-key j select-pane -D
        bind-key k select-pane -U
        bind-key l select-pane -R

        # switch windows using Shift-arrow without prefix
        bind -n S-Left previous-window
        bind -n S-Right next-window

        # rename window to reflect current program
        setw -g automatic-rename on

        # renumber windows when a window is closed
        set -g renumber-windows on

        # statusbar
        set-option -g status-position top

        # auto save and restore sessions with tmux-continuum/resurrect
        set -g @continuum-save-interval '5'
        set -g @continuum-boot 'on'

        # resurrect automatically
        set -g @continuum-restore 'on'
        set -g @resurrect-capture-pane-contents 'on'

        set -g @tokyo-night-theme "storm"
      '';
    };

  home.file = {
    ".gitconfig" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/users/eowusu/dotfiles/.gitconfig";
      force = false;
    };

    ".zshrc" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/users/eowusu/dotfiles/.zshrc";
      force = true;
    };

    #zsh theme
    ".p10k.zsh" = {
      source = ./dotfiles/.p10k.zsh;
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
