{ lib, pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    clock24 = true;
    historyLimit = 9999999;
    mouse = true;
    baseIndex = 1;
    escapeTime = 0;
    prefix = "C-a";
    shell = lib.getExe pkgs.zsh;
    sensibleOnTop = true;
    terminal = "tmux-256color";
    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = tokyo-night-tmux;
        extraConfig = ''
          set -g @tokyo-night-theme "storm"
        '';
      }
      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-capture-pane-contents 'on'
        '';
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-save-interval '5'
          set -g @continuum-boot 'on'
          set -g @continuum-restore 'on'
        '';
      }
      vim-tmux-navigator
    ];
    extraConfig = ''
      # reload config file
      bind r source-file ~/.config/tmux/tmux.conf \; display-message "~/.config/tmux/tmux.conf reloaded."

      setw -g xterm-keys on

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

      # Kitty keyboard protocol passthrough (for Shift+Enter in opencode)
      set -ga terminal-overrides ",*:XT"
      set -g allow-passthrough on

      # Translate Shift+Enter to Alt+Enter for opencode
      bind -n S-Enter send-keys M-Enter
    '';
  };
}
