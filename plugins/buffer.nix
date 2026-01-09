{
  config,
  lib,
  ...
}: let
  inherit (config.nvix.mkKey) mkKeymap wKeyObj;
  inherit (lib.nixvim) mkRaw;
in {
  plugins = {
    bufferline = {
      enable = true;
      settings.options = rec {
        diagnostics = "nvim_lsp";
        separator_style = "slope";
        show_buffer_close_icons = false;
        # compact
        tab_size = 0;
        always_show_bufferline = true;
        indicator.style = "underline";
        offsets = [
          {
            filetype = "snacks_layout_box";
            text = "Snacks Explorer";
            highlight = "Directory";
            text_align = "center";
          }
          {
            filetype = "dapui_scopes";
            text = "DAP UI";
            highlight = "Directory";
            text_align = "center";
          }
        ];
      };
    };
  };

  wKeyList = [
    (wKeyObj [
      "<leader>b"
      ""
      "buffers"
    ])
    (wKeyObj [
      "<leader><tab>"
      ""
      "tabs"
    ])
  ];

  keymaps = [
    (mkKeymap "n" "<leader>qc" "<cmd>:bp | bd #<cr>" "Buffer close")

    (mkKeymap "n" "<leader>bP" "<cmd>BufferLineTogglePin<cr>" "Buffer Pin")
    (mkKeymap "n" "<leader>bd" "<cmd>BufferLineSortByDirectory<cr>" "Buffer Sort by dir")
    (mkKeymap "n" "<leader>be" "<cmd>BufferLineSortByExtension<cr>" "Buffer Sort by ext")
    (mkKeymap "n" "<leader>bt" "<cmd>BufferLineSortByTabs<cr>" "Buffer Sort by Tabs")
    (mkKeymap "n" "<leader>bL" "<cmd>BufferLineCloseRight<cr>" "Buffer close all to right")
    (mkKeymap "n" "<leader>bH" "<cmd>BufferLineCloseLeft<cr>" "Buffer close all to left")
    (
      mkKeymap "n" "<leader>bc" "<cmd>BufferLineCloseOther<cr>"
      "Buffer close all except the current buffer"
    )
  ];
  theovim.keymaps.global.n = {
    "<Tab>" = {
      action = "<cmd>BufferLineCycleNext<cr>";
      description = "Cycle to next buffer";
    };
    "<S-Tab>" = {
      action = "<cmd>BufferLineCyclePrev<cr>";
      description = "Cycle to previous buffer";
    };
    "<leader>bh" = {
      action = "<cmd>BufferLineMovePrev<cr>";
      description = "Move buffer to left";
    };
    "<leader>bl" = {
      action = "<cmd>BufferLineMoveNext<cr>";
      description = "Move buffer to right";
    };
  };
}
