{lib, ...}: let
  inherit (lib.nixvim.plugins) mkNeovimPlugin;
in
  mkNeovimPlugin {
    name = "flirt";
    maintainers = [];
    url = "https://github.com/tamton-aquib/flirt.nvim";
    description = "A neovim plugin to work with floating windows. ";
  }
