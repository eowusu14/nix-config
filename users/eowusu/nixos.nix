{ pkgs, user, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  programs.zsh.enable = true;
  services.openssh.enable = true;

  users.users.${user} = {
    isNormalUser = true;
    home = "/home/${user}";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ];
  };
}
