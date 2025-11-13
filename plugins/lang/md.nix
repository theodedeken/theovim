{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (config.nvix.mkKey) wKeyObj;
  inherit (config.nvix) icons;
  inherit (lib.nixvim) mkRaw;
in {
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
    mkdnflow = {
      enable = true;
      settings = {
        to_do.symbols = [" " "⧖" "x"];
        mappings = {
          MkdnEnter = {
            key = "<cr>";
            modes = ["n" "i"];
          };
          MkdnToggleToDo = {
            key = "<c-space>";
            modes = ["n" "i"];
          };
        };
      };
    };
  };

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
}
