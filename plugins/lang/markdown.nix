{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (config.nvix.mkKey) wKeyObj;
  inherit (lib.nixvim) mkRaw;
in
  with lib; {
    options.theovim.lang.markdown.enable = mkEnableOption "Enable markdown support";
    config =
      mkIf config.theovim.lang.markdown.enable
      {
        plugins = {
          img-clip.enable = true;
          markdown-preview = {
            enable = true;
          };

          render-markdown = {
            enable = true;
            settings = {
              code = {
                width = "block";
                left_margin = 2;
                left_pad = 2;
                right_pad = 2;
              };
            };
          };
        };
        plugins.conform-nvim.settings = {
          formatters_by_ft.markdown = ["mdformat" "injected"];
          formatters.mdformat = {
            append_args = ["--wrap" "100"];
          };
        };
        extraPackages = [pkgs.mdformat];
        # TODO: switch to theovim keymap
        autoCmd = [
          {
            desc = "Setup Markdown mappings";
            event = "Filetype";
            pattern = "markdown";
            callback =
              mkRaw # lua
              
              ''
                function()
                -- Set keymap: <leader>p to save and convert to PDF using pandoc
                vim.api.nvim_buf_set_keymap(0, 'n', '<leader>pb', '<cmd>MarkdownPreview<CR>', { desc = "Markdown Browser Preview", noremap = true, silent = true })
                end
              '';
          }
        ];

        wKeyList = [
          (wKeyObj ["<leader>p" "" "preview"])
        ];
      };
  }
