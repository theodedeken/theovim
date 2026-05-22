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
      lsp.servers = {
        # Code Quality
        ruff.enable = true;
        # LSP
        pyrefly =
          {
            enable = true;
            # Always strict typechecking
          }
          // (
            # Deprecated but still needed until pyrefly 1.0
            if (builtins.compareVersions pkgs.pyrefly.version "1.0.0") < 0
            then {config.settings.python.pyrefly.displayTypeErrors = "force-on";}
            else {config.settings.python.pyrefly.typeCheckingMode = "strict";}
          );
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
