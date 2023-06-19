alias v := dev
alias vim := dev
alias nvim := dev
# Execute local nvim source in a nix dev shell
dev *NVIM_ARGS:
  nix develop -c nvim {{NVIM_ARGS}}
