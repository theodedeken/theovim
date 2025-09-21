{
  config,
  lib,
  ...
}: let
  inherit (config.nvix) icons;
  inherit (lib.nixvim) mkRaw;
in {
  plugins.lualine.settings.sections = {
    lualine_a = [
      {
        __unkeyed = "fileformat";
        cond = null;
        padding = {
          left = 1;
          right = 1;
        };
        color = "SLGreen";
      }
    ];
    lualine_b = ["encoding"];
    lualine_c = [
      {
        __unkeyed = "b:gitsigns_head";
        icon = "${icons.git.Branch}";
        color.gui = "bold";
      }
      {
        __unkeyed = "diff";
        source =
          mkRaw # lua
          
          ''
            (function()
              local gitsigns = vim.b.gitsigns_status_dict
              if vim.b.gitsigns_status_dict then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end)
          '';
        symbols = {
          added = mkRaw ''"${icons.git.LineAdded}" .. " " '';
          modified = mkRaw ''"${icons.git.LineModified}".. " "'';
          removed = mkRaw ''"${icons.git.LineRemoved}".. " "'';
        };
      }
      {
        __unkeyed = "diagnostics";
        sources = {
          __unkeyed = "nvim_diagnostic";
        };
        symbols = {
          error = mkRaw ''"${icons.diagnostics.BoldError}" .. " "'';
          warn = mkRaw ''"${icons.diagnostics.BoldWarning}" .. " "'';
          info = mkRaw ''"${icons.diagnostics.BoldInformation}" .. " "'';
          hint = mkRaw ''"${icons.diagnostics.BoldHint}" .. " "'';
        };
      }
    ];
    lualine_x = [
      {
        color = {
          fg = "#ff9e64";
        };
        cond = mkRaw ''
          function()
            local ok, noice = pcall(require, "noice")
            if not ok then
              return false
            end
            return noice.api.status.mode.has()
          end
        '';
        __unkeyed =
          mkRaw # lua
          
          ''
            function()
              local ok, noice = pcall(require, "noice")
              if not ok then
                return false
              end
              return noice.api.status.mode.get()
            end
          '';
      }
      {
        __unkeyed =
          mkRaw # lua
          
          ''
            function()
              local bufnr = vim.fn.bufnr()
              -- Get clients attached to current buffer
              local clients = vim.lsp.get_clients({bufnr = bufnr})
              local lsp_names = {}
              for _, client in ipairs(clients) do
                  local name = client.name:gsub("%[%d+%]", "") -- makes otter-ls[number] -> otter-ls
                  table.insert(lsp_names, name)
              end

              if next(lsp_names) == nil then
                return "Ls Inactive"
              end
              return "[" .. table.concat(vim.fn.uniq(lsp_names), ", ") .. "]"
            end
          '';
        on_click =
          mkRaw #lua
          
          ''
            function()
              vim.cmd("LspInfo")
            end
          '';
      }

      {
        __unkeyed = "filetype";
        cond = null;
        padding = {
          left = 1;
          right = 1;
        };
      }
      {
        __unkeyed =
          mkRaw # lua
          
          ''
            function()
              return "autoformat OFF"
            end
          '';
        cond =
          mkRaw #lua
          
          ''
            function()
              return vim.g.disable_autoformat or vim.b.disable_autoformat
            end
          '';
      }
    ];
    lualine_y = ["progress"];
    lualine_z = [
      "location"
      {
        __unkeyed =
          mkRaw # lua
          
          ''
            function()
              local lsp_clients = vim.lsp.get_clients()
              for _, client in ipairs(lsp_clients) do
                if client.name == "copilot" then
                  return "%#SLGreen#" .. "${icons.kind.Copilot}"
                end
              end
               return ""
            end
          '';
      }
    ];
  };
}
