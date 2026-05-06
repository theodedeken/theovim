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
      lsp.servers = {
        yamlls.enable = true;
      };
      plugins = {
        conform-nvim.settings.formatters_by_ft.yaml = ["yq"];
        treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [yaml];
      };
    };
  }
