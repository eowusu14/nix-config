{ inputs, self }:
{ kind, system, modules }:
if kind == "darwin" then
  inputs.nix-darwin.lib.darwinSystem {
    inherit system modules;
    specialArgs = { inherit inputs self; };
  }
else if kind == "nixos" then
  inputs.nixpkgs.lib.nixosSystem {
    inherit system modules;
    specialArgs = { inherit inputs self; };
  }
else
  throw "Unsupported system kind: ${kind}"
