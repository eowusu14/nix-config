{ self, pkgs, config, ... }:
{
  users.users."owusu.boateng" = {
    home = "/Users/owusu.boateng";
    shell = pkgs.zsh;
  };

  system.primaryUser = "owusu.boateng";

  environment.systemPackages = [
    pkgs.tmux
    pkgs.obsidian
  ];

  homebrew = {
    enable = true;
    brews = [
      "mas"
    ];
    casks = [
      "hammerspoon"
      "firefox"
      "iina"
      "the-unarchiver"
    ];
    masApps = {
      "Yoink" = 457622435;
    };
    onActivation.cleanup = "zap";
  };

  fonts.packages = [
    pkgs.nerd-fonts."jetbrains-mono"
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
        echo "copying $src" >&2
        ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
        /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f "/Applications/Nix Apps/$app_name" >/dev/null 2>&1 || true
      done
    '';

  system.defaults = {
    dock.autohide = true;
    dock.largesize = 64;
    dock.persistent-apps = [
      "/Applications/Obsidian.app"
      "/System/Applications/Calendar.app"
    ];
    finder.FXPreferredViewStyle = "clmv";
    loginwindow.GuestEnabled = false;
    NSGlobalDomain.AppleICUForce24HourTime = true;
    NSGlobalDomain.AppleInterfaceStyle = "Dark";
    NSGlobalDomain.KeyRepeat = 2;
  };

  nix.settings.experimental-features = "nix-command flakes";
  programs.zsh.enable = true;
  system.configurationRevision = self.rev or self.dirtyRev or null;
  nix.enable = false;
}
