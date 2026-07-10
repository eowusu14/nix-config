{ self, inputs, pkgs, config, user, ... }:
{
  users.users.${user} = {
    home = "/Users/${user}";
    shell = pkgs.zsh;
  };

  system.primaryUser = user;

  environment.systemPackages = [
    pkgs.alt-tab-macos
    # pkgs.codex
    pkgs.discord
    pkgs.hidden-bar
    pkgs.net-news-wire
    pkgs.nix
    pkgs.nodejs
    pkgs.prek
    pkgs.gh
    pkgs.ripgrep
    pkgs.tree
    pkgs.aerospace
    pkgs.gopls
    pkgs.protobuf
    # pkgs.qemu
  ];

  nix-homebrew = {
    enable = true;
    user = user;
    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
      "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
    };
    mutableTaps = false;
  };

  homebrew = {
    enable = true;
    taps = builtins.attrNames config.nix-homebrew.taps;
    onActivation = {
      cleanup = "none";
      autoUpdate = false;
      upgrade = false;
    };
    global.autoUpdate = false;

    brews = [
      "herdr"
      # "iina"
      "k9s"
      "lazydocker"
      "lazygit"
      "mas"
      "mole"
      "neovim"
      # "tailscale"
      # "qemu"
      "python3"
      #"uv"
      "samba"
      "go"

    ];
    casks = [
      # "alt-tab"
      #"aws-vpn-client"
      "arc"
      "brave-browser"
      "capcut"
      "codex"
      # "discord"
      "dbeaver-community"
      "firefox"
      "free-download-manager"
      "ghostty"
      # "hiddenbar"
      # "iina"
      "iterm2"
      "obsidian"
      "netnewswire"
      # "okta-verify"
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
      "whatsapp"
      "zoom"

    ];
    extraConfig = ''
      cask "pgadmin4", args: { force: true }
    '';
    masApps = {
      "Amphetamine" = 937984704;
      "Infuse" = 1136220934;
      #"Whatsapp" = 310633997;
      #"Capcut" = 1500855883;
      # "Xcode" = 497799835;
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

  # macOS Configuration
  system.defaults = {
    dock.autohide = true;
    dock.largesize = 64;
    dock.persistent-apps = [
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
    CustomUserPreferences = {
      NSGlobalDomain = {
        NSWindowShouldDragOnGesture = true;
      };
    };

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
