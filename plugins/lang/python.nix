{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib.nixvim) mkRaw;
in
  with lib; {
    options = {theovim.lang.python.enable = mkEnableOption "Enable python language support";};
    config = mkIf config.theovim.lang.python.enable {
      plugins.lsp.servers = {
        # Code Quality
        ruff.enable = true;
        # LSP
        zuban = {
          enable = true;
        };
      };
      # Handle formatting of python code blocks
      plugins.conform-nvim.settings.formatters.injected.options.lang_to_formatters.python = ["ruff_format"];
      # Debugging
      plugins = {
        dap-python = {
          enable = true;
          testRunner = "pytest";
        };
      };
      plugins.treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [python];
      theovim.keymaps.python.n = {
        "<leader>tm" = {
          action = mkRaw "require'dap-python'.test_method";
          description = "Run the nearest test";
        };
      };
    };
  }
