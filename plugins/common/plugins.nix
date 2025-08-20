{
  pkgs,
  config,
  ...
}: let
  inherit (config.nvix.mkKey) mkKeymap;
in {
  nixpkgs.overlays = [
    (final: prev: {
      vimPlugins =
        prev.vimPlugins
        // {
          # FIXME: remove once vim coach is packaged in nix
          vim-coach = pkgs.callPackage ../packages/vim-coach-package.nix {
            inherit
              (pkgs.vimUtils)
              buildVimPlugin
              ;
          };
        };
    })
  ];

  plugins = {
    vim-coach.enable = true;
    # Must have plugins to have a decent flow of work
    comment = {
      enable = true;
      settings = {
        toggler.line = "<leader>/";
        opleader.line = "<leader>/";
      };
    };
    tmux-navigator.enable = true;
    smart-splits.enable = true;
    web-devicons.enable = true;
    nvim-surround.enable = true;
    nvim-autopairs.enable = true;
    trim.enable = true;
    lz-n.enable = true;
    flash = {
      enable = true;
      settings = {
        modes.char.enabled = false;
      };
    };
    which-key = {
      enable = true;
      settings.spec = config.wKeyList;
      settings.preset = "helix";
    };
  };
  opts = {
    timeout = true;
    timeoutlen = 250;
  };
  keymaps = [
    (mkKeymap "n" "<leader>vt" "<cmd>:lua require('flash').treesitter()<cr>" "Select Treesitter Node")
  ];
}
