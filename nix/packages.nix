{ pkgs, ... }: with pkgs; rec {

  # Require by vim-go plugin
  # https://github.com/fatih/vim-go/blob/1401b576c6ac382529188d3d26cff866139f2f9a/plugin/go.vim#L42
  goPackages = [
    asmfmt # assembler formatter
    delve # Debugger
    errcheck # Checks for unchecked errors in go programs
    go-motion
    go-tools # Bunch of tools, includes [staticcheck, keyify]
    godef # Print where symbols are defined in Go source code
    golangci-lint
    golint
    gomodifytags
    gopls # Go LSP
    gotools # Bunch of tools, includes [goimports, guru, gorename, gotags]
    iferr
    impl
    reftools # Refactoring tools. vim-go uses fillstruct
    revive # Linter
  ];

  packages = [
    fzf
    git
    nil
    nixpkgs-fmt
    ormolu # Haskell formatter
    nodejs-slim # Runs project-local node tools, like prettier via neoformat
    bash-language-server
    prettier # Used to format several languages
    typescript-language-server
    yaml-language-server
    rumdl # Markdown LSP and linter
    tree-sitter
    shfmt
    helm-ls # Helm LSP
    harper # Grammar and spelling LSP (harper-ls)
    vscode-langservers-extracted # Includes html, css, json LSPs

    # Terraform LSP packages
    terraform-ls
    tflint

    # Lua
    lua-language-server
    stylua
    luajitPackages.jsregexp # used by luasnip
  ] ++ goPackages;
  packagesPath = lib.makeBinPath packages;
}
