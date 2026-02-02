{lib, ...}: let
  inherit (lib.nixvim) mkRaw;
in {
  plugins.codecompanion = {
    enable = true;
    settings = {
      strategies.chat.adapter = "gemini";
      strategies.inline.adapter = "gemini";

      # Configure Gemini HTTP adapter
      adapters.http.gemini = mkRaw ''
        function()
          return require("codecompanion.adapters").extend("gemini", {
            env = {
              api_key = "cmd:cat /run/agenix/gemini_key",
            },
            schema = {
              model = {
                default = "gemini-3-flash-preview",
              },
            },
          })
        end
      '';
    };
  };

  # Global keymap configuration for CodeCompanion integration
  theovim.keymaps.global = {
    # Normal mode: Toggle the CodeCompanion chat window
    n."<leader>ai" = {
      description = "Open chat window";
      action = "<cmd>CodeCompanionChat Toggle<cr>";
    };
    # Visual mode: Open a prompt to run an AI command on the current selection
    v."<leader>ai" = {
      description = "Prompt on the current selection";
      action = mkRaw ''
        function()
          vim.ui.input({ prompt = "󰫢: " }, function(input)
            if not input or input == "" then
              return
            end
            -- Execute CodeCompanion command on the visually selected range
            vim.cmd("'<,'>CodeCompanion " .. input)
          end)
        end
      '';
    };
  };
  theovim.keygroups."<leader>a" = {
    icon = "󰫢";
    name = "AI";
  };
  # Fidget spinner for model interaction, based on:
  # https://github.com/olimorris/codecompanion.nvim/discussions/813#discussioncomment-12031954
  plugins.fidget.luaConfig.post =
    #lua
    ''
      local CCSpinner = {}
      CCSpinner.handles = {}

      function CCSpinner:store_progress_handle(id, handle)
        CCSpinner.handles[id] = handle
      end

      function CCSpinner:pop_progress_handle(id)
        local handle = CCSpinner.handles[id]
        CCSpinner.handles[id] = nil
        return handle
      end

      function CCSpinner:create_progress_handle(request)
        return require("fidget.progress").handle.create({
          title = " Requesting assistance (" .. request.data.interaction .. ")",
          message = "In progress...",
          lsp_client = {
            name = CCSpinner:llm_role_title(request.data.adapter),
          },
        })
      end

      function CCSpinner:llm_role_title(adapter)
        local parts = {}
        table.insert(parts, adapter.formatted_name)
        if adapter.model and adapter.model ~= "" then
          table.insert(parts, "(" .. adapter.model .. ")")
        end
        return table.concat(parts, " ")
      end

      function CCSpinner:report_exit_status(handle, request)
        if request.data.status == "success" then
          handle.message = "Completed"
        elseif request.data.status == "error" then
          handle.message = " Error"
        else
          handle.message = "󰜺 Cancelled"
        end
      end
    '';
  autoGroups.CodeCompanionFidgetHooks = {};
  autoCmd = [
    {
      event = "User";
      pattern = "CodeCompanionRequestStarted";
      group = "CodeCompanionFidgetHooks";
      callback = mkRaw ''
        function(request)
          local handle = CCSpinner:create_progress_handle(request)
          CCSpinner:store_progress_handle(request.data.id, handle)
        end
      '';
    }
    {
      event = "User";
      pattern = "CodeCompanionRequestFinished";
      group = "CodeCompanionFidgetHooks";
      callback = mkRaw ''
        function(request)
          local handle = CCSpinner:pop_progress_handle(request.data.id)
          if handle then
            CCSpinner:report_exit_status(handle, request)
            handle:finish()
          end
        end
      '';
    }
  ];

  imports = with builtins;
  with lib;
    map (fn: ./${fn}) (
      filter (fn: (fn != "default.nix" && !hasSuffix ".md" "${fn}")) (attrNames (readDir ./.))
    );
}
