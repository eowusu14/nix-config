{ inputs, self }:

name:
{
  system,
  user,
  profile ? user,
  hostName ? name,
  darwin ? false,
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

  specialArgs = { inherit inputs self user hostName darwin; };

  modules = [
    { nixpkgs.config.allowUnfree = true; }
    {
      # tmux 3.7c's configure script now requires an explicit jemalloc choice
      # on Darwin. Nixpkgs does not enable jemalloc there, so select the
      # supported no-jemalloc build explicitly.
      nixpkgs.overlays = [
        (final: prev: {
          tmux = prev.tmux.overrideAttrs (old: {
            configureFlags = old.configureFlags
              ++ prev.lib.optionals prev.stdenv.hostPlatform.isDarwin [ "--disable-jemalloc" ];
          });
        })
      ];
    }
    machineConfig
    userOSConfig
    homeManagerModule
    (if darwin then inputs.nix-homebrew.darwinModules.nix-homebrew else { })
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "backup";
      home-manager.extraSpecialArgs = {
        inherit inputs self user darwin;
      };
      home-manager.users.${user} = userHMConfig;
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
