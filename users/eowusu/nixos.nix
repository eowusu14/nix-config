{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.tmux
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  services.openssh.enable = true;

  users.users.eowusu = {
    isNormalUser = true;
    home = "/home/eowusu";
    extraGroups = [ "wheel" ];
  };
}
