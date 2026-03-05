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
  userHMConfig = ../users/${profile}/home-manager.nix;

  systemFunc = if darwin then inputs.nix-darwin.lib.darwinSystem else inputs.nixpkgs.lib.nixosSystem;
  homeManagerModule = if darwin then inputs.home-manager.darwinModules.home-manager else inputs.home-manager.nixosModules.home-manager;
in
systemFunc {
  inherit system;

  specialArgs = { inherit inputs self user hostName; };

  modules = [
    { nixpkgs.config.allowUnfree = true; }
    machineConfig
    userOSConfig
    homeManagerModule
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "backup";
      home-manager.extraSpecialArgs = {
        inherit inputs self;
      };
      home-manager.users.${user} = import userHMConfig {
        inherit inputs user darwin;
      };
    }
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
