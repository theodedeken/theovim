{config, ...}: let
  inherit (config.nvix.mkKey) mkKeymap;
in {
  keymaps = [
    (mkKeymap "n" "<leader>e" "<cmd>:lua Snacks.explorer({resumable = false})<cr>" "Snacks Explorer")
  ];
}
