{
  description = "Erik's Neovim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/23.05";
    unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { flake-utils, nixpkgs, ... }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs { inherit system; };
          extraPackages = with pkgs; [
            fzf
            git
            nil
            nixpkgs-fmt
            ormolu # Haskell formatter
            nodejs-slim_20
            nodePackages.bash-language-server
            nodePackages.prettier # Used to format several languages
            nodePackages.typescript-language-server
            nodePackages.yaml-language-server
            marksman # Markdown LSP
            tree-sitter
            shfmt
            gopls # Go LSP
            go-tools # vim-go
            delve # Debugger for Go
            helm-ls # Helm LSP

            # Terraform LSP packages
            terraform-ls
            tflint

            # Lua
            lua-language-server
            stylua
          ];
          binPath = pkgs.lib.makeBinPath extraPackages;
          styler-nvim = with pkgs; vimUtils.buildVimPlugin {
            name = "styler.nvim";
            pname = "styler.nvim";
            src = fetchFromGitHub {
              owner = "folke";
              repo = "styler.nvim";
              rev = "d5b7e43af4fdaa06e4175c84f4f57b633ae7e6ff";
              sha256 = "sha256-BlePqxukucbrUPqk4NzqXsw+3RC/jU9WOpy40D0NbwQ=";
            };
          };
          vim-just = with pkgs; vimUtils.buildVimPlugin {
            name = "vim-just";
            pname = "vim-just";
            src = fetchFromGitHub {
              owner = "NoahTheDuke";
              repo = "vim-just";
              rev = "3451e22daade268f99b1cfeb0d9fe39f4ddc06d5";
              sha256 = "sha256-2pzdtMGdmCTprkPslGdlEezdQ6dTFrhqvz5Sc8DN3Ts";
            };
          };
          vim-helm = with pkgs; vimUtils.buildVimPlugin {
            name = "vim-helm";
            pname = "vim-helm";
            src = fetchFromGitHub {
              owner = "towolf";
              repo = "vim-helm";
              rev = "c2e7b85711d410e1d73e64eb5df7b70b1c4c10eb";
              sha256 = "sha256-NQXmIcDnUqbeiNX0QqvQbLGmONuC8HGFlfsBHBXWEc4=";
            };
          };
          vim-kdl = with pkgs; vimUtils.buildVimPlugin {
            name = "kdl";
            pname = "kdl";
            src = fetchFromGitHub {
              owner = "imsnif";
              repo = "kdl.vim";
              rev = "b84d7d3a15d8d30da016cf9e98e2cfbe35cddee5";
              sha256 = "sha256-IajKK1EjrKs6b2rotOj+RlBBge9Ii2m/iuIuefnjAE4=";
            };
          };

          plugins = with pkgs.vimPlugins; [
            # common (used by other plugins)
            plenary-nvim
            nvim-web-devicons

            # UI
            alpha-nvim
            telescope-nvim
            fidget-nvim

            # Theming
            styler-nvim
            catppuccin-nvim
            tokyonight-nvim

            # Controls
            comment-nvim

            # Syntax
            indent-blankline-nvim
            nvim-treesitter-textobjects
            nvim-treesitter.withAllGrammars
            nvim-lspconfig
            neoformat

            # Completions
            nvim-cmp
            cmp-nvim-lsp
            cmp-buffer
            cmp-path
            cmp_luasnip
            cmp-cmdline
            lspkind-nvim
            cmp-tabnine
            nvim-autopairs
            luasnip
            friendly-snippets

            # Specific language support
            vim-just
            vim-helm
            vim-kdl
            vim-go
            vim-terraform
            haskell-tools-nvim
            neoconf-nvim
            neodev-nvim
            rust-tools-nvim
          ];
          packpathDirs.myNeovimPackages = {
            start = plugins;
            opt = [ ];
          };
          initFile = pkgs.writeTextFile {
            name = "init.lua";
            text = ''
              vim.loader.enable()
              vim.opt.rtp:append("${./nvim}")
              vim.g.plugin_config_dir = "${./nvim/lua/plugins}"
              require("core")
            '';
          };
          neovimConfig = pkgs.neovimUtils.makeNeovimConfig
            {
              customRC = "luafile ${initFile}";
            } // {
            inherit packpathDirs;
            viAlias = true;
            vimAlias = true;
            withNodeJs = false;
            withPython3 = false;
            withRuby = false;
            wrapperArgs = pkgs.lib.escapeShellArgs [ "--suffix" "PATH" ":" "${binPath}" ];
          };
        in
        with pkgs;
        rec {
          packages.envim = wrapNeovimUnstable neovim-unwrapped neovimConfig;
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
              just
              stylua
            ];
          };
        });
}
