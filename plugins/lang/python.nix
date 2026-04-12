{
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
        basedpyright = {
          enable = true;
          settings = {
            basedpyright.disableOrganizeImports = true;
            # Do not analyse for types when there are none
            basedpyright.analysis.useLibraryCodeForTypes = false;
          };
        };
      };
      # Handle formatting of python code blocks
      plugins.conform-nvim.settings.formatters.injected.options.lang_to_formatters.python = ["ruff_format"];
      # Typechecking
      plugins = {
        none-ls = {
          enable = true;
          sources.diagnostics.mypy.enable = true;
        };
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
