{lib, ...}: let
  inherit (lib.nixvim) mkRaw;
in {
  plugins.toggleterm = {
    enable = true;
    settings = {
      persist_mode = true;
      start_in_insert = false;
    };
  };
  theovim.syntax-highlight.ignore-ft = ["toggleterm"];
  theovim.keymaps.global.n = let
    goto-file = dir:
      mkRaw ''
        function()
          local file = vim.fn.expand("<cfile>")
          vim.cmd("wincmd ${dir}")
          vim.cmd("edit " .. file)
        end'';
    goto-file-loc = dir:
      mkRaw ''
        function()
          local file = vim.fn.expand("<cfile>")
          local cWORD = vim.fn.expand('<cWORD>')
          local escaped_path = file:gsub("([%-%.%+%?%*%^%$%(%)%%])", "%%%1")
          local line_match, col_match = cWORD:match(escaped_path .. ":(%d+):(%d+)")

          if line_match then
            line_num = tonumber(line_match)
            col_num = tonumber(col_match)
            pos = {line_num, col_num}
          else
            -- Fallback: try matching path:line
            line_match = cWORD:match(escaped_path .. ":(%d+)")
            if line_match then
              line_num = tonumber(line_match)
              pos = {line_num, 0}
            else
              pos = nil
            end
          end
          vim.cmd("wincmd ${dir}")
          vim.cmd("edit " .. file)
          if pos ~= nil then
            vim.api.nvim_win_set_cursor(0, pos)
          end
        end
      '';
  in {
    "<A-t>" = {
      action = ":ToggleTerm direction=horizontal name=main size=24<CR>";
      description = "Toggle terminal on the bottom";
    };
    "<A-T>" = {
      action = ":ToggleTerm direction=vertical name=main size=80<CR>";
      description = "Toggle terminal on the side";
    };
    # Special gf/gF mapping which opens the file under cursor in the window above
    # Otherwise the terminal window would be closed
    "-gf" = {
      action = goto-file "k";
      description = "Go to file in above window";
    };
    "-gF" = {
      action = goto-file-loc "k";
      description = "Go to file and location in above window";
    };
    "|gf" = {
      action = goto-file "j";
      description = "Go to file in left wndow";
    };
    "|gF" = {
      action = goto-file-loc "j";
      description = "Go to file and location in left window";
    };
    "<leader>ft" = {
      action = ":TermSelect<CR>";
      description = "Select a terminal";
    };
  };
}
