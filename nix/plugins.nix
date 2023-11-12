{ pkgs, unpkgs, ... }: with pkgs;
let
  styler-nvim = vimUtils.buildVimPlugin {
    name = "styler.nvim";
    pname = "styler.nvim";
    src = fetchFromGitHub {
      owner = "folke";
      repo = "styler.nvim";
      rev = "d5b7e43af4fdaa06e4175c84f4f57b633ae7e6ff";
      sha256 = "sha256-BlePqxukucbrUPqk4NzqXsw+3RC/jU9WOpy40D0NbwQ=";
    };
  };
  vim-just = vimUtils.buildVimPlugin {
    name = "vim-just";
    pname = "vim-just";
    src = fetchFromGitHub {
      owner = "NoahTheDuke";
      repo = "vim-just";
      rev = "3451e22daade268f99b1cfeb0d9fe39f4ddc06d5";
      sha256 = "sha256-2pzdtMGdmCTprkPslGdlEezdQ6dTFrhqvz5Sc8DN3Ts";
    };
  };
  vim-helm = vimUtils.buildVimPlugin {
    name = "vim-helm";
    pname = "vim-helm";
    src = fetchFromGitHub {
      owner = "towolf";
      repo = "vim-helm";
      rev = "c2e7b85711d410e1d73e64eb5df7b70b1c4c10eb";
      sha256 = "sha256-NQXmIcDnUqbeiNX0QqvQbLGmONuC8HGFlfsBHBXWEc4=";
    };
  };
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

  unstablePlugins = with unpkgs.vimPlugins; [
    indent-blankline-nvim
  ];

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
  ] ++ unstablePlugins;
in
{
  inherit plugins;
}
