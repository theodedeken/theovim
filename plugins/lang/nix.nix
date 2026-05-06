{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  options.theovim.lang.nix.enable = mkEnableOption "Enable nix language support";
  config =
    mkIf config.theovim.lang.nix.enable
    {
      extraPackages = [pkgs.alejandra];
      lsp.servers = {
        nixd = {
          enable = true;
        };
        statix.enable = true;
      };
      plugins = {
        conform-nvim.settings = {
          formatters_by_ft.nix = ["alejandra" "injected"];
          formatters.alejandra = {
            command = "alejandra";
          };
        };
        treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [nix];
      };
    };
}
