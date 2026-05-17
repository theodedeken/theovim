{
  config,
  lib,
  ...
}: let
  inherit (lib.nixvim) mkRaw;
  inherit (config.nvix.mkKey) mkKeymap wKeyObj;
  mkBufKeymap = key: action: {
    key = key;
    action = action;
  };
in {
  wKeyList = [
    (wKeyObj ["<leader>lg" "" "goto"])
    (wKeyObj ["<leader>l" "󰿘" "lsp"])
  ];
  theovim.keymaps.global.n."<leader>lh" = {
    action = mkRaw ''function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end'';
    description = "Toggle inlay hints";
  };
  lsp.keymaps = [
    # Lspsaga

    (mkKeymap "n" "<leader>la" "<cmd>:Lspsaga code_action<cr>" "Code Action")
    (mkKeymap "n" "<leader>lo" "<cmd>Lspsaga outline<cr>" "Outline")
    (mkKeymap "n" "gd" "<cmd>Lspsaga goto_definition<cr>" "Definitions")
    (mkKeymap "n" "<leader>lr" "<cmd>Lspsaga rename ++project<cr>" "Rename")
    (mkKeymap "n" "gt" "<cmd>Lspsaga goto_type_definition<cr>" "Type Definitions")
    (mkKeymap "n" "gpd" "<cmd>Lspsaga peek_definition<cr>" "Peek Definition")
    (mkKeymap "n" "gpt" "<cmd>Lspsaga peek_type_definition<cr>" "Peek Type Definition")
    (mkKeymap "n" "[e" "<cmd>Lspsaga diagnostic_jump_prev<cr>" "Jump Prev Diagnostic")
    (mkKeymap "n" "]e" "<cmd>Lspsaga diagnostic_jump_next<cr>" "Jump Next Diagnostic")
    (mkKeymap "n" "K"
      (mkRaw ''
        function()
          local ok, ufo = pcall(require, "ufo")
          if ok then
            winid = ufo.peekFoldedLinesUnderCursor()
          end
          if not winid then
            vim.cmd("Lspsaga hover_doc")
          end
        end
      '') "Hover Doc")

    (mkKeymap "n" "<leader>lq" "<CMD>LspStop<Enter>" "Stop LSP")
    (mkKeymap "n" "<leader>li" "<cmd>checkhealth vim.lsp<cr>" "LSP Info")
    (mkKeymap "n" "<leader>ls" "<CMD>LspStart<Enter>" "Start LSP")
    (mkKeymap "n" "<leader>lR" "<CMD>lsp restart<Enter>" "Restart LSP")

    (mkKeymap "n" "<C-s-k>" "<cmd>:lua vim.lsp.buf.signature_help()<cr>" "Signature Help")
    (mkKeymap "n" "<leader>lD" "<cmd>:lua Snacks.picker.lsp_definitions()<cr>" "Definitions list")
    (mkKeymap "n" "<leader>ls" "<cmd>:lua Snacks.picker.lsp_symbols()<cr>" "Definitions list")

    (mkKeymap "n" "<leader>lf" "<cmd>:lua require('conform').format()<cr>" "Format file")
    (mkKeymap "x" "<leader>lf" "<cmd>:lua require('conform').format()<cr>" "Format File")
    (mkKeymap "v" "<leader>lf" "<cmd>:lua require('conform').format()<cr>" "Format File")

    (mkBufKeymap "gD" "declaration")
    (mkBufKeymap "gi" "implementation")
    (mkBufKeymap "gy" "type_definition")

    (mkKeymap "n" "[d" "<cmd>:lua vim.diagnostic.goto_prev()<cr>" "Previous Diagnostic")
    (mkKeymap "n" "]d" "<cmd>:lua vim.diagnostic.goto_next()<cr>" "Next Diagnostic")

    (mkKeymap "n" "<leader>ll"
      (
        mkRaw # lua
        
        ''
          function()
            if vim.diagnostic.config().virtual_text == false then
              vim.diagnostic.config({ virtual_text = { source = "always" } })
            else
              vim.diagnostic.config({ virtual_text = false })
            end
          end
        ''
      ) "Toggle Virtual Text")
  ];

  theovim.keymaps.global.n.gr = {
    action = mkRaw "function() Snacks.picker.lsp_references() end";
    description = "Show references";
  };
}
