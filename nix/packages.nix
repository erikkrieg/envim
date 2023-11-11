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
    helm-ls # Helm LSP

    # For Go (vim-go plugin)
    gopls # Go LSP
    delve # Debugger
    go-tools # vim-go
    revive # Linter


    # Terraform LSP packages
    terraform-ls
    tflint

    # Lua
    lua-language-server
    stylua
  ];
  packagesPath = lib.makeBinPath packages;
}
