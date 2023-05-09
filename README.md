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

_Note: if packer is not installed then it will bootstrap and then sync plugins the first time `nvim` is run. Once complete, either `:source` the config or start a new nvim process._

