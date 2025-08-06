{
  lib,
  config,
  ...
}: let
  inherit (config.nvix.mkKey) wKeyObj;
in {
  imports = [./snacks];

  wKeyList = [
    (wKeyObj [
      "<leader>e"
      ""
      "explorer"
    ])
  ];
}
