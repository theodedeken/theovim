{
  lib,
  config,
  ...
}: let
  inherit (config.nvix) icons;
  inherit (lib.nixvim) toRawKeys;
in {
  theovim.keymaps.global.n."<leader>lw" = {
    action = "<cmd>:lua Snacks.picker.diagnostics()<cr>";
    description = "Show workspace diagnostics";
  };

  diagnostic.settings = {
    virtual_text = false;
    underline = true;
    # Set up signs and highlights for diagnostics
    signs = {
      text = with icons.diagnostics;
        toRawKeys {
          "vim.diagnostic.severity.HINT" = BoldHint;
          "vim.diagnostic.severity.INFO" = BoldInformation;
          "vim.diagnostic.severity.WARN" = BoldWarning;
          "vim.diagnostic.severity.ERROR" = BoldError;
        };
      texthl = toRawKeys {
        "vim.diagnostic.severity.HINT" = "DiagnosticSignHint";
        "vim.diagnostic.severity.INFO" = "DiagnosticSignInfo";
        "vim.diagnostic.severity.WARN" = "DiagnosticSignWarn";
        "vim.diagnostic.severity.ERROR" = "DiagnosticSignError";
      };
      numhl = toRawKeys {
        "vim.diagnostic.severity.HINT" = "DiagnosticSignHint";
        "vim.diagnostic.severity.INFO" = "DiagnosticSignInfo";
        "vim.diagnostic.severity.WARN" = "DiagnosticSignWarn";
        "vim.diagnostic.severity.ERROR" = "DiagnosticSignError";
      };
    };
    severity_sort = true;
    float = {
      border = config.nvix.border;
      source = "always";
      focusable = false;
    };
  };
}
