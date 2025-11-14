{
  lib,
  config,
  pkgs,
  ...
}: let
in
  with lib; {
    options = {
      theovim.lang.json.enable = mkEnableOption "Enable json support";
    };
    config = mkIf config.theovim.lang.json.enable {
      extraPackages = with pkgs; [yq];
      plugins = {
        conform-nvim.settings.formatters_by_ft.json = ["yq"];
        lsp.servers = {
          jsonls.enable = true;
        };
      };
    };
  }
