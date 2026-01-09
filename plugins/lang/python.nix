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
            pyright.disableOrganizeImports = true;
          };
        };
      };
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
      theovim.keymaps.python.n = {
        "<leader>tm" = {
          action = mkRaw "require'dap-python'.test_method";
          description = "Run the nearest test";
        };
      };
    };
  }
