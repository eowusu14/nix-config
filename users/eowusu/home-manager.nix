{ user, darwin ? false, ... }:
{ lib, pkgs, ... }:
{
  home.username = user;
  home.homeDirectory = if darwin then "/Users/${user}" else "/home/${user}";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
  home.packages = [
    pkgs.zsh-powerlevel10k
    pkgs.chruby
    pkgs.uv
  ];

  programs.git = {
    enable = true;
    settings = {
      user = {
        email = "owusuboateng149@gmail.com";
        name = "eowusu14";
      };
      init = {
        defaultBranch = "main";
      };
      merge = {
        conflictStyle = "diff3";
        tool = "meld";
      };
      pull = {
        rebase = true;
      };
      alias = {
        undo = "reset HEAD~1 --soft";
        unstage = "reset HEAD --";
        uncommit = "reset HEAD~1 --soft";
        recommit = "commit --amend --no-edit";
        get = "pull origin";
        push = "push origin HEAD";
        commit = "commit -m";
        add = "add -p";
        log = "log --graph --all --pretty=format:%C(auto)%h %C(cyan)%ar %C(auto)%d %C(magenta)%an %C(auto)%s";
      };
    };
  };

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
    tmux.enableShellIntegration = false;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      path = if darwin then "/Users/${user}/.zhistory" else "/home/${user}/.zhistory";
      save = 1000;
      size = 999;
      share = true;
      expireDuplicatesFirst = true;
      ignoreDups = true;
    };

    shellAliases = {
      ls = "eza --icons=always";
      k = "bin/kubectl";
      "kctx-staging" = "kubectl config use-context arn:aws:eks:us-west-2:149938346436:cluster/primary-staging";
      "kctx-prod" = "kubectl config use-context arn:aws:eks:us-west-2:149938346436:cluster/primary-production";
      "kctx-preprod" = "kubectl config use-context arn:aws:eks:us-west-2:676657780981:cluster/primary-preprod";
      chaws = "~/github/cloud/bin/kubectl env";
      kns = "~/github/cloud/bin/kubectl ns";
      cd = "z";
    };

    initContent = ''
      export PATH="$HOME/.volta/bin:$PATH"
      export PATH="/usr/local/opt/curl/bin:$PATH"
      export LDFLAGS="-L/usr/local/opt/openssl/lib"
      export CPPFLAGS="-I/usr/local/opt/openssl/include"
      export GOPATH="$HOME/go"
      export PATH="$GOPATH/bin:$HOME/.local/bin:$PATH"

      # powerlevel10k instant prompt
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi

      ${lib.optionalString darwin ''
      if [[ -r "${pkgs.chruby}/share/chruby/chruby.sh" ]]; then
        source "${pkgs.chruby}/share/chruby/chruby.sh"
      fi
      if [[ -r "${pkgs.chruby}/share/chruby/auto.sh" ]]; then
        source "${pkgs.chruby}/share/chruby/auto.sh"
      fi
      if command -v chruby >/dev/null 2>&1; then
        chruby ruby-3.1.3 || true
      fi
      ''}

      source "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme"

      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

      bindkey '^[[A' history-search-backward
      bindkey '^[[B' history-search-forward

      if command -v uv >/dev/null 2>&1; then
        eval "$(uv generate-shell-completion zsh)"
      fi
      if command -v uvx >/dev/null 2>&1; then
        eval "$(uvx --generate-shell-completion zsh)"
      fi

      # rancher desktop path
      export PATH="$HOME/.rd/bin:$PATH"
    '';
  };

  programs.tmux = {
    enable = true;
    mouse = true;
    historyLimit = 9999999;
    terminal = "tmux-256color";
    keyMode = "vi";
    baseIndex = 1;
    escapeTime = 0;
    extraConfig = ''
      unbind r
      bind r source-file ~/.config/tmux/tmux.conf
      set -g default-shell /bin/zsh
      set -g default-command "exec /bin/zsh -l"
      # Keep manually renamed windows stable.
      setw -g automatic-rename off
      setw -g allow-rename off
      setw -g allow-set-title off
      setw -g automatic-rename-format "#{window_name}"
      # Re-apply on creation so restored/new windows don't drift.
      set-hook -g after-new-window "set-window-option automatic-rename off; set-window-option allow-rename off; rename-window zsh"
      # Prefer friendly name for first window in new sessions.
      set-hook -g after-new-session "rename-window zsh"
      # Don't let tmux overwrite the terminal/tab title.
      set -g set-titles off
      setw -g pane-base-index 1
      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R
      set-option -g status-position top
      set -g status-right "%H:%M %d-%b-%y"
      # Catppuccin defaults to #T (pane title), which is host name on this setup.
      set -g @catppuccin_window_text " #W"
      set -g @catppuccin_window_current_text " #W"
      set -g window-status-format "#[fg=#11111b,bg=#{@thm_overlay_2}] #I #[fg=#cdd6f4,bg=#{@thm_surface_0}] #W "
      set -g window-status-current-format "#[fg=#11111b,bg=#{@thm_mauve}] #I #[fg=#cdd6f4,bg=#{@thm_surface_1}] #W "

      set -g @continuum-save-interval '5'
      set -g @continuum-boot 'on'
      set -g @continuum-restore 'on'
      set -g @resurrect-capture-pane-contents 'on'
    '';

    plugins = with pkgs.tmuxPlugins; [
      catppuccin
      resurrect
      continuum
      sensible
      vim-tmux-navigator
    ];
  };

  home.file = {
    ".tmux.conf" = {
      text = ''
        source-file ~/.config/tmux/tmux.conf
      '';
      force = true;
    };
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
