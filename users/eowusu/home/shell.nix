{
  config,
  darwin,
  lib,
  pkgs,
  ...
}:
let
  sessionPath =
    lib.optionals darwin [ "/opt/homebrew/opt/libpq/bin" ]
    ++ [
      "$HOME/.npm-global/bin"
      "$HOME/go/bin"
      "$HOME/.local/bin"
    ]
    ++ lib.optionals darwin [
      "$HOME/.rd/bin"
    ];
in
{
  home = {
    sessionVariables.GOPATH = "$HOME/go";
    inherit sessionPath;
  };

  programs.zsh = {
    enable = true;

    # Keep the current ~/.zshrc location when Home Manager eventually changes
    # its default to an XDG directory for newer state versions.
    dotDir = config.home.homeDirectory;

    autosuggestion.enable = true;
    historySubstringSearch.enable = true;

    syntaxHighlighting = {
      enable = true;
      styles = {
        command = "fg=green";
        alias = "fg=green";
        builtin = "fg=green";
        function = "fg=green";
      };
    };

    history = {
      path = "${config.home.homeDirectory}/.zhistory";
      size = 999;
      save = 1000;
      append = false;
      extended = false;
      expireDuplicatesFirst = true;
      findNoDups = false;
      ignoreAllDups = false;
      ignoreDups = true;
      ignoreSpace = true;
      saveNoDups = false;
      share = true;
    };

    setOptions = [
      "HIST_VERIFY"
      "PROMPT_SUBST"
    ];

    shellAliases = {
      cd = "z";
    };

    initContent = lib.mkMerge [
      # Powerlevel10k requires its instant prompt before interactive setup.
      (lib.mkOrder 500 ''
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
      '')

      # Re-prepend declared session paths after system shell initialization and
      # register Docker completions before Home Manager calls compinit.
      (lib.mkOrder 540 ''
        path=(
          ${lib.concatMapStringsSep "\n  " (path: ''"${path}"'') sessionPath}
          $path
        )
        ${lib.optionalString darwin ''
          [[ -d "$HOME/.docker/completions" ]] && fpath=("$HOME/.docker/completions" $fpath)
        ''}
      '')

      # fzf's widgets must exist before fzf-tab takes ownership of Tab.
      (lib.mkOrder 600 ''
        if [[ $options[zle] = on ]]; then
          source <(${lib.getExe pkgs.fzf} --zsh)
        fi
      '')

      # fzf-tab must load after compinit and before autosuggestions.
      (lib.mkOrder 650 ''
        source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
      '')

      (lib.mkOrder 675 ''
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        [[ ! -f "$HOME/.p10k.zsh" ]] || source "$HOME/.p10k.zsh"
      '')

      (lib.mkOrder 1050 ''
        [[ $commands[kubectl] ]] && source <(kubectl completion zsh)

        ${lib.optionalString darwin ''
          # Open macOS GUI apps from Terminal, e.g. `app "Visual Studio Code"`.
          app() {
            open -a "$*"
          }
        ''}
      '')
    ];
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

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
    # Loaded explicitly above so fzf-tab can be ordered after it.
    enableZshIntegration = false;
    tmux.enableShellIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}
