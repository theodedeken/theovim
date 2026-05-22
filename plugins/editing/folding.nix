{lib, ...}: let
  inherit (lib.nixvim) mkRaw;
in {
  opts = {
    foldcolumn = "1";
    foldlevel = 99;
    foldenable = true;
    foldnestmax = 5;
  };
  plugins.nvim-ufo = {
    enable = true;
    settings = {
      provider_selector =
        # lua
        ''
          function(bufnr, filetype, buftype)
              return {'treesitter', 'indent'}
          end
        '';
      preview.mappings = {
        close = "q";
        switch = "K";
      };
      # https://github.com/kevinhwang91/nvim-ufo#customize-fold-text
      fold_virt_text_handler = mkRaw ''
        function(virtText, lnum, endLnum, width, truncate)
            local newVirtText = {}
            local suffix = (' 󰁂 %d '):format(endLnum - lnum)
            local sufWidth = vim.fn.strdisplaywidth(suffix)
            local targetWidth = width - sufWidth
            local curWidth = 0
            for _, chunk in ipairs(virtText) do
                local chunkText = chunk[1]
                local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                if targetWidth > curWidth + chunkWidth then
                    table.insert(newVirtText, chunk)
                else
                    chunkText = truncate(chunkText, targetWidth - curWidth)
                    local hlGroup = chunk[2]
                    table.insert(newVirtText, {chunkText, hlGroup})
                    chunkWidth = vim.fn.strdisplaywidth(chunkText)
                    -- str width returned from truncate() may less than 2nd argument, need padding
                    if curWidth + chunkWidth < targetWidth then
                        suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
                    end
                    break
                end
                curWidth = curWidth + chunkWidth
            end
            table.insert(newVirtText, {suffix, 'MoreMsg'})
            return newVirtText
        end
      '';
    };
  };
  theovim.keygroups."z" = {
    icon = ">";
    name = "fold";
  };
  theovim.keymaps.global.n = {
    "zR" = {
      action = mkRaw ''require("ufo").openAllFolds'';
      description = "Open all folds";
    };
    "zM" = {
      action = mkRaw ''require("ufo").closeAllFolds'';
      description = "Close all folds";
    };
  };
}
