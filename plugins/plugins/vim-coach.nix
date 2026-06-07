{lib, ...}: let
  inherit (lib.nixvim.plugins) mkNeovimPlugin;
in
  mkNeovimPlugin {
    name = "vim-coach";
    maintainers = [];
    url = "https://github.com/shahshlok/vim-coach.nvim";
    description = "Your Personal Coach for Neovim";
  }
