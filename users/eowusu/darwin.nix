{ self, pkgs, config, user, ... }:
{
  users.users.${user} = {
    home = "/Users/${user}";
    shell = pkgs.zsh;
  };

  system.primaryUser = user;

  environment.systemPackages = [
    pkgs.alt-tab-macos
    pkgs.codex
    pkgs.discord
    pkgs.hidden-bar
    pkgs.nix
    pkgs.nodejs
    pkgs.gh
    pkgs.ripgrep
    pkgs.tree
    pkgs.aerospace
    pkgs.gopls
    # pkgs.qemu
  ];

  homebrew = {
    enable = true;
    onActivation = {
       cleanup = "none";
       # Update brew packages on rebuild
       autoUpdate = true;
       upgrade = true;
     };
     global.autoUpdate = true;

    brews = [
      # "iina"
      "k9s"
      "lazydocker"
      "lazygit"
      "mas"
      "neovim"
      # "tailscale"
      # "qemu"
      "python3"
      "uv"
      "samba"
      "go"

    ];
    casks = [
      # "alt-tab"
      "aws-vpn-client"
      "brave-browser"
      "codex"
      # "discord"
      "firefox"
      "free-download-manager"
      "ghostty"
      # "hiddenbar"
      # "iina"
      "iterm2"
      "obsidian"
      # "okta-verify"
      "pgadmin4"
      "postman"
      "rectangle"
      "syncthing-app"
      # "tailscale-app"
      "visual-studio-code"
      "zed"
      #"neovim"
      # "google-chrome"
      "raycast"
      "spotify"
      "slack"
      # "tailscale-app"
      "telegram"
      "the-unarchiver"
      "tor-browser"
      "vlc"
      "zoom"

    ];
    masApps = {
      "Amphetamine" = 937984704;
      "Telegram" = 747648890;
      "Infuse" = 1136220934;
      "Whatsapp" = 310633997;
      "Capcut" = 1500855883;
      "Xcode" = 497799835;
    };
  };

  fonts.packages = [
    pkgs.ia-writer-mono
    pkgs.ibm-plex
    pkgs.nerd-fonts."jetbrains-mono"
    pkgs.nerd-fonts."meslo-lg"
    pkgs.nerd-fonts.fira-code
    pkgs.nerd-fonts.fira-mono
    pkgs.nerd-fonts.hack
  ];

  system.activationScripts.applications.text =
    let
      env = pkgs.buildEnv {
        name = "system-applications";
        paths = config.environment.systemPackages;
        pathsToLink = [ "/Applications" ];
      };
    in
    pkgs.lib.mkForce ''
      echo "setting up /Applications..." >&2
      rm -rf /Applications/Nix\ Apps
      mkdir -p /Applications/Nix\ Apps
      find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
      while IFS= read -r src; do
        app_name=$(basename "$src")
        echo "copying app bundle $src" >&2
        /usr/bin/ditto "$src" "/Applications/Nix Apps/$app_name"
        /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f "/Applications/Nix Apps/$app_name" >/dev/null 2>&1 || true
      done
    '';

  # macOS Configuration
  system.defaults = {
    dock.autohide = true;
    dock.largesize = 64;
    dock.persistent-apps = [
      "/Applications/Google Chrome.app"
      "/Applications/Obsidian.app"
      "/System/Applications/Books.app"
      "/Applications/Slack.app"
      "/Applications/Visual Studio Code.app"
      "/Applications/Ghostty.app"
      "/Applications/Zed.app"
    ];
    dock.show-recents = false;

    finder.FXPreferredViewStyle = "clmv";
    finder.ShowStatusBar = true;
    loginwindow.GuestEnabled = false;
    NSGlobalDomain.AppleICUForce24HourTime = true;
    NSGlobalDomain.AppleInterfaceStyle = "Dark";
    NSGlobalDomain.AppleShowAllExtensions = true;
    NSGlobalDomain.KeyRepeat = 2;
    NSGlobalDomain."com.apple.trackpad.scaling" = 2.5;

    trackpad = {
      Clicking = true;
      TrackpadRightClick = true;
    };
  };

  nix.settings.experimental-features = "nix-command flakes";
  programs.zsh.enable = true;
  system.configurationRevision = self.rev or self.dirtyRev or null;
  nix.enable = false;
}
