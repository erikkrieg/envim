{ pkgs, unpkgs, ... }: with pkgs;
let
  /* Example of fetching a plugin from GitHub 
    vim-kdl = vimUtils.buildVimPlugin {
      name = "kdl";
      pname = "kdl";
      src = fetchFromGitHub {
        owner = "imsnif";
        repo = "kdl.vim";
        rev = "b84d7d3a15d8d30da016cf9e98e2cfbe35cddee5";
        sha256 = "sha256-IajKK1EjrKs6b2rotOj+RlBBge9Ii2m/iuIuefnjAE4=";
      };
    };
  */

  unstablePlugins = with unpkgs.vimPlugins; [
    actions-preview-nvim
    indent-blankline-nvim
    fidget-nvim
  ];

  plugins = with pkgs.vimPlugins; [
    # common (used by other plugins)
    plenary-nvim
    nvim-web-devicons

    # UI
    alpha-nvim
    lualine-nvim
    oil-nvim
    telescope-nvim
    which-key-nvim

    # Theming
    styler-nvim
    catppuccin-nvim
    tokyonight-nvim

    # Controls
    comment-nvim

    # Syntax
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
    nvim-autopairs
    luasnip
    friendly-snippets
    cmp-tabnine
    copilot-lua # Also copilot-vim from GH available
    copilot-cmp

    # Specific language support
    vim-just
    vim-helm
    kdl-vim
    vim-go
    vim-terraform
    haskell-tools-nvim
    neoconf-nvim
    neodev-nvim
    rust-tools-nvim
  ] ++ unstablePlugins;
in
{
  inherit plugins;
}
