# Custom nixvim plugin to show a screensaver with the current directory when the window loses focus
{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib.nixvim) mkRaw;
in
  with lib; {
    options.plugins.dir-saver.enable = mkEnableOption "Enable current directory screensaver";
    config = mkIf config.plugins.dir-saver.enable {
      globals = {
        figlet_bin = "${pkgs.figlet}/bin/figlet";
        figlet_win = mkRaw "nil";
        figlet_buf = mkRaw "nil";
      };
      autoGroups.FigletScreenSaver.clear = true;
      autoCmd = [
        {
          event = ["FocusLost"];
          group = "FigletScreenSaver";
          pattern = ["*"];
          callback = mkRaw ''
            function ()
              if vim.g.figlet_win and vim.api.nvim_win_is_valid(vim.g.figlet_win) then
                return
              end

              -- Get the tail of the cwd
              local last_dir = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")

              -- Render using figlet
              local figlet_cmd = string.format("%s -f basic -c -w %d '%s'", vim.g.figlet_bin, vim.o.columns - 4, last_dir)
              local figlet_output = vim.fn.systemlist(figlet_cmd)

              -- Vertical center
              local total_rows = vim.o.lines - vim.o.cmdheight -- Houd rekening met de command line onderin
              local top_padding_size = math.max(0, math.floor((total_rows - #figlet_output) / 2))

              local final_output = {}
              for i = 1, top_padding_size do
                table.insert(final_output, "")
              end
              for _, line in ipairs(figlet_output) do
                table.insert(final_output, line)
              end

              -- Show window
              vim.g.figlet_buf = vim.api.nvim_create_buf(false, true)
              vim.api.nvim_buf_set_lines(vim.g.figlet_buf, 0, -1, false, final_output)

              local width = vim.o.columns
              local height = vim.o.lines

              local opts = {
                relative = "editor",
                width = width,
                height = height,
                row = 0,
                col = 0,
                style = "minimal",
                border = "none",
              }

              vim.g.figlet_win = vim.api.nvim_open_win(vim.g.figlet_buf, false, opts)

             -- Coloring
              vim.wo[vim.g.figlet_win].winhl = "Normal:Keyword"
            end
          '';
        }
        {
          event = ["FocusGained"];
          group = "FigletScreenSaver";
          pattern = ["*"];
          callback = mkRaw ''
            function()
              if vim.g.figlet_win and vim.api.nvim_win_is_valid(vim.g.figlet_win) then
                vim.api.nvim_win_close(vim.g.figlet_win, true)
              end
              if vim.g.figlet_buf and vim.api.nvim_buf_is_valid(vim.g.figlet_buf) then
                vim.api.nvim_buf_delete(vim.g.figlet_buf, { force = true })
              end
              vim.g.figlet_win = nil
              vim.g.figlet_buf = nil
            end
          '';
        }
      ];
    };
  }
