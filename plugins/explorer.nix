{
  pkgs,
  config,
  ...
}: let
  inherit (config.nvix.mkKey) wKeyObj;
  inherit (config.nvix.mkKey) mkKeymap;
in {
  imports = [./snacks];
  # Snacks explorer requires this package for file searching
  extraPackages = [pkgs.fd];
  wKeyList = [
    (wKeyObj [
      "<leader>e"
      ""
      "explorer"
    ])
  ];
  keymaps = [
    (mkKeymap "n" "<leader>e" "<cmd>:lua Snacks.explorer({hidden = true})<cr>" "Snacks Explorer")
  ];
}
