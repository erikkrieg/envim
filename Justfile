alias v := dev
alias vim := dev
alias nvim := dev
alias b := build

# Fast dev iteration with working directory config
dev *NVIM_ARGS:
  envim {{NVIM_ARGS}}

# Clean build test (uses Nix store paths)
build *NVIM_ARGS:
  nix run . -- {{NVIM_ARGS}}

