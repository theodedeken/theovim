{
  lib,
  config,
  pkgs,
  ...
}: let
in
  with lib; {
    options = {
      theovim.lang.yaml.enable = mkEnableOption "Enable yaml support";
    };
    config = mkIf config.theovim.lang.yaml.enable {
      extraPackages = with pkgs; [yq];
      plugins = {
        conform-nvim.settings.formatters_by_ft.yaml = ["yq"];
        lsp.servers = {
          yamlls.enable = true;
        };
        treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [yaml];
      };
    };
  }
