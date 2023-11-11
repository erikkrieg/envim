{ pkgs, ... }: {
  inherit (import ./plugins.nix { inherit pkgs; }) plugins;
  inherit (import ./packages.nix { inherit pkgs; }) packagesPath;
}
