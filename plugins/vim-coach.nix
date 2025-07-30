{
  inputs,
  pkgs,
  lib,
  ...
}: let
  inherit (inputs.nixvim.lib.nixvim.plugins) mkNeovimPlugin;
in
  mkNeovimPlugin {
    name = "vim-coach";
    packPathName = "vim-coach.nvim";
    maintainers = [];
    url = "https://github.com/shahshlok/vim-coach.nvim";
    description = "Your Personal Coach for Neovim";
  }
  // {
    config = {
      plugins.vim-coach.package = pkgs.callPackage ./vim-coach-package.nix {
        inherit
          (pkgs.vimUtils)
          buildVimPlugin
          ;
      };
    };
  }
