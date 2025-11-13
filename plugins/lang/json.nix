{
  lib,
  config,
  ...
}: let
in
  with lib; {
    options = {
      theovim.lang.json.enable = mkEnableOption "Enable json support";
    };
    config = mkIf config.theovim.lang.json.enable {
      plugins = {
        lsp.servers = {
          jsonls.enable = true;
        };
      };
    };
  }
