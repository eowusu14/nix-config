{ inputs, self }:

name:
{
  system,
  user,
  profile ? user,
  hostName ? name,
  darwin ? false
}:

let
  machineConfig = ../machines/${name}.nix;
  userOSConfig = ../users/${profile}/${if darwin then "darwin" else "nixos"}.nix;

  systemFunc = if darwin then inputs.nix-darwin.lib.darwinSystem else inputs.nixpkgs.lib.nixosSystem;
in
systemFunc {
  inherit system;

  specialArgs = { inherit inputs self; };

  modules = [
    { nixpkgs.config.allowUnfree = true; }
    machineConfig
    userOSConfig
    { networking.hostName = hostName; }
    {
      config._module.args = {
        currentSystem = system;
        currentSystemName = name;
        currentSystemUser = user;
        currentHostName = hostName;
        inherit inputs self;
      };
    }
  ];
}
