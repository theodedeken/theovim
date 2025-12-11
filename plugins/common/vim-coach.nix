{lib, ...}: let
  inherit (lib.nixvim.plugins) mkNeovimPlugin;
in
  mkNeovimPlugin {
    name = "vim-coach";
    # packPathName = "vim-coach.nvim";
    maintainers = [];
    url = "https://github.com/shahshlok/vim-coach.nvim";
    description = "Your Personal Coach for Neovim";
  }
