{
  description = "Erik's Neovim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-25.05";
    unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { flake-utils, nixpkgs, unstable, ... }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          unpkgs = import unstable {
            inherit system;
            config.allowUnfree = true;
          };
          inherit (import ./nix { inherit pkgs unpkgs; }) plugins packagesPath;
          initFile = pkgs.writeTextFile {
            name = "init.lua";
            text = ''
              vim.loader.enable()
              local rtp = vim.env.NVIM_RTP or "${./nvim}"
              vim.opt.rtp:append(rtp)
              vim.g.plugin_config_dir = vim.env.NVIM_PLUGIN_CONFIG_DIR or (rtp .. "/lua/plugins")
              require("core")
            '';
          };
          neovimConfig = pkgs.neovimUtils.makeNeovimConfig
            {
              customRC = "luafile ${initFile}";
            } // {
            viAlias = true;
            vimAlias = true;
            withNodeJs = false;
            withPython3 = false;
            withRuby = false;
            plugins = plugins;
            wrapperArgs = pkgs.lib.escapeShellArgs [ "--suffix" "PATH" ":" "${packagesPath}" ];
          };
        in
        with pkgs;
        rec {
          packages.envim = wrapNeovimUnstable neovim-unwrapped neovimConfig;
          packages.envim-dev = pkgs.writeShellScriptBin "envim" ''
            exec ${packages.envim}/bin/nvim "$@"
          '';
          packages.default = packages.envim;
          apps.envim = flake-utils.lib.mkApp {
            drv = packages.envim;
            name = "envim";
            exePath = "/bin/nvim";
          };
          apps.default = apps.envim;
          devShell = mkShell {
            buildInputs = [
              packages.envim-dev
              just
              stylua
              nixpkgs-fmt
            ];
            shellHook = ''
              export XDG_DATA_HOME="$(pwd)/.dev/data"
              export XDG_STATE_HOME="$(pwd)/.dev/state"
              export XDG_CACHE_HOME="$(pwd)/.dev/cache"
              mkdir -p $XDG_DATA_HOME $XDG_STATE_HOME $XDG_CACHE_HOME
              export NVIM_RTP="$(pwd)/nvim"
              export NVIM_PLUGIN_CONFIG_DIR="$(pwd)/nvim/lua/plugins"
            '';
          };
        });
}
