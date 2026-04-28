{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  options.theovim.lang.toml.enable = mkEnableOption "Enable toml language support";
  config =
    mkIf config.theovim.lang.toml.enable
    {
      plugins.lsp.servers.taplo.enable = true;
      plugins.conform-nvim.settings = {
        formatters_by_ft.toml = ["taplo"];
        formatters.taplo.command = "taplo format";
      };
      plugins.treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [toml];
    };
}
