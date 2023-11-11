{ pkgs, ... }: with pkgs; rec {
  packages = [
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
  packagesPath = lib.makeBinPath packages;
}
