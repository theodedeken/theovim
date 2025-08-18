{
  pkgs,
  config,
  ...
}: let
  inherit (config.nvix.mkKey) wKeyObj;
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
}
