# Debug support for neovim
{lib, ...}: let
  inherit (lib.nixvim) mkRaw;
in {
  plugins.dap = {
    enable = true;
    luaConfig.post =
      # lua
      ''
        vim.fn.sign_define('DapBreakpoint', {text='', texthl="Error", linehl="", numhl=""})
        vim.fn.sign_define('DapBreakpointCondition', {text='', texthl="WarningMsg", linehl="", numhl=""})
        vim.fn.sign_define('DapStopped', {text='󰁚', texthl="Character", linehl="DapStopped", numhl=""})

        vim.api.nvim_set_hl(0, "DapStopped", { bg="#577d5d" })
      '';
  };
  plugins.dap-ui = {
    enable = true;
    # Automatically open the UI when starting a debug session
    luaConfig.post =
      # lua
      ''
        local dap = require("dap")
        local dapui = require("dapui")
        dapui.setup(opts)
        dap.listeners.after.event_initialized["dapui_config"] = function()
          dapui.open({})
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
          dapui.close({})
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
          dapui.close({})
        end
      '';
  };
  plugins.dap-virtual-text.enable = true;
  theovim.keymaps.global.n = {
    "<leader>du" = {
      action = mkRaw ''function() require("dapui").toggle({ }) end'';
      description = "Toggle DAP UI";
    };
    "<leader>db" = {
      action = mkRaw ''function() require("dap").toggle_breakpoint() end'';
      description = "Toggle Breakpoint";
    };
    "<leader>dB" = {
      action = mkRaw ''function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end'';
      description = "Toggle Conditional Breakpoint";
    };
  };
  theovim.keygroups."<leader>d" = {
    icon = "";
    name = "debug";
  };
}
