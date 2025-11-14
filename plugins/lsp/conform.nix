# Formatter with lsp fallback
{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.nixvim) mkRaw;
  inherit (config.nvix.mkKey) mkKeymap;
in {
  plugins.conform-nvim = {
    enable = true;
    settings = {
      formatters_by_ft = {
        "_" = [
          "squeeze_blanks"
          "trim_whitespace"
          "trim_newlines"
        ];
      };
      formatters.squeeze_blanks.command = lib.getExe' pkgs.coreutils "cat";
      # Always format on save
      # Based on: https://github.com/stevearc/conform.nvim/issues/192
      format_on_save =
        mkRaw # Lua
        
        ''
          function(bufnr)
            -- Disable with a global or buffer-local variable
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
              return
            end
            return { timeout_ms = 500, lsp_format = "first" }
          end
        '';
    };
  };
  keymaps = [
    (mkKeymap "n" "<leader>tf"
      (
        mkRaw # lua
        
        ''
          function()
            -- If autoformat is currently disabled for this buffer,
            -- then enable it, otherwise disable it
            if vim.b.disable_autoformat then
              vim.b.disable_autoformat = false
              vim.notify 'Enabled autoformat for current buffer'
            else
              vim.b.disable_autoformat = true
              vim.notify 'Disabled autoformat for current buffer'
            end
          end
        ''
      ) "Toggle autoformat for this buffer")
    (mkKeymap "n" "<leader>tF"
      (
        mkRaw # lua
        
        ''
          function()
            -- If autoformat is currently disabled globally,
            -- then enable it globally, otherwise disable it globally
            if vim.g.disable_autoformat then
              vim.g.disable_autoformat = false
              vim.notify 'Enabled autoformat globally'
            else
              vim.g.disable_autoformat = true
              vim.notify 'Disabled autoformat globally'
            end
          end
        ''
      ) "Toggle autoformat globally")
  ];
}
