{
  description = "Erik's Neovim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, flake-utils, nixpkgs, ... }: 
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs { inherit system; };
    in with pkgs; rec {
      packages.envim = wrapNeovim neovim-unwrapped {
        viAlias = true;
        vimAlias = true;
        withNodeJs = false;
        withPython3 = false;
        withRuby = false;
        extraPython3Packages = false;
        configure = {
          customRC = ''
            lua << EOF
            vim.o.runtimepath = table.concat({ 
              "${self}/nvim", "${self}/nvim/after",
              vim.o.runtimepath
            }, ",")
            ''
            + pkgs.lib.readFile ./init.lua
            + ''EOF'';
        };
      };
      packages.default = packages.envim;
      apps.envim = flake-utils.lib.mkApp {
        drv = packages.envim;
        name = "envim";
        exePath = "/bin/nvim";
      };
      apps.default = apps.envim;
      devShell = mkShell {
        buildInputs = [packages.envim];
      };
    });
}

