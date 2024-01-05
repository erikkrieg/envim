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

### Grammar support with LSP

The [`ltex` LSP server](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#ltex) supports language models that can be used to suggest fixes for more nuanced grammar issues. These models are rather large, so I opted to exclude packaging it directly. While the model is missing, the ltex lsp server still works, but to get more capabilities you can download [ngrams](https://dev.languagetool.org/finding-errors-using-n-gram-data.html) and unzip the model at `~/models/ngrams`.

> Unzip it and put it in its own directory named en, de, fr, or es, depending on the language. The path you need to set in the next step is the directory that the en etc. directory is in, not that directory itself.

So, in my case I have `~/models/ngrams/en`.
