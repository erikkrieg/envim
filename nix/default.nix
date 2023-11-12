{ pkgs, unpkgs, ... }: {
  inherit (import ./plugins.nix { inherit pkgs unpkgs; }) plugins;
  inherit (import ./packages.nix { inherit pkgs unpkgs; }) packagesPath;
}
