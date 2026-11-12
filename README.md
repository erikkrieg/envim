# Envim (Erik's nvim)

Terminal-first development and source controlled configuration with [Neovim](https://github.com/neovim/neovim) and a splash of [Nix](https://nixos.org/guides/how-nix-works.html).

## Usage

Envim is available as a [nix flake](https://nixos.wiki/wiki/flakes) and is best installed with a something like [Nix Home Manager](https://github.com/nix-community/home-manager). Here's the Nix configuration I use: https://github.com/erikkrieg/eksys

There are a few other nix-y ways to run envim without installing it at the system or user level.

Build and run envim with [nix run](https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-run.html):

```sh
nix run github:erikkrieg/envim
```

While in the root of the envim directory [run in a new shell containing the build environment](https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-develop.html):

```sh
nix develop
```

### Grammar and spelling

[Harper](https://github.com/Automattic/harper) checks grammar and spelling in Markdown files and Git commit messages. It runs offline and needs no language model download. To also check comments in code, add filetypes to the `harper_ls` config in `nvim/lua/plugins/lsp/servers/init.lua`.

### Markdown

[rumdl](https://github.com/rvben/rumdl) lints Markdown. Saving a file runs prettier and then applies rumdl's fixes, so rumdl wins where the two disagree. `<leader>F` applies rumdl's fixes without saving.
