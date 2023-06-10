{
  description = "Erik's Neovim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, flake-utils, nixpkgs, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        extraPackages = with pkgs; [
          fzf
          git
          nil
          nixpkgs-fmt
          nodejs-slim_20
          nodePackages.bash-language-server
          nodePackages.prettier # Used to format several languages
          nodePackages.typescript-language-server
          nodePackages.yaml-language-server
          tree-sitter
          shfmt
          # rust-analyzer - not installed here because I define it in my nix-shells

          # Lua 
          lua-language-server
          stylua
        ];
      in
      with pkgs; rec {
        packages.envim = wrapNeovim neovim-unwrapped {
          viAlias = true;
          vimAlias = true;
          withNodeJs = false;
          withPython3 = false;
          withRuby = false;
          extraPython3Packages = false;
          extraMakeWrapperArgs = ''--prefix PATH : "${lib.makeBinPath extraPackages}"'';
          configure = {
            customRC = ''
              lua << EOF
              vim.o.runtimepath = table.concat({ 
                "${self}/nvim", "${self}/nvim/after",
                vim.o.runtimepath
              }, ",")
            ''
            + pkgs.lib.readFile ./nvim/init.lua
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
          buildInputs = [
            packages.envim
            stylua
          ];
          # Sets up plugins in a local dir to allow testing without impacting user plugins.
          shellHook = ''
            alias c="clear"
            alias l="ls -la"
            alias v="nvim"
            export XDG_DATA_HOME="$(pwd)/.data"
            mkdir -p $XDG_DATA_HOME
            nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
            tabnine="$XDG_DATA_HOME/nvim/site/pack/packer/start/cmp-tabnine"
            if [ ! -f "$tabnine/binaries/.active" ]; then
              "$tabnine/install.sh"
            fi
            echo
          '';
        };
      });
}
