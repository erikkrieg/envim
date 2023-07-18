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
          marksman # Markdown LSP
          tree-sitter
          shfmt
          gopls # Go LSP
          helm-ls # Helm LSP
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
                "${self}/nvim", vim.o.runtimepath
              }, ",")
            ''
            + pkgs.lib.readFile ./nvim/init.lua
            + ''
              -- User autocmd does not have config in path without this
              vim.opt.rtp:prepend("${self}/nvim")
            ''
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
            export XDG_DATA_HOME="$(pwd)/.dev/data"
            export XDG_STATE_HOME="$(pwd)/.dev/state"
            export XDG_CACHE_HOME="$(pwd)/.dev/cache"
            mkdir -p $XDG_DATA_HOME $XDG_STATE_HOME $XDG_CACHE_HOME
          '';
        };
      });
}
