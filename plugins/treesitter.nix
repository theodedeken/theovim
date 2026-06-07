{
  lib,
  config,
  ...
}: let
  inherit (lib.nixvim) mkRaw toLuaObject;
in {
  options = with lib; {
    theovim.syntax-highlight.ignore-ft = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Filetypes to ignore when searching for syntax highlighting";
    };
  };
  config = {
    plugins = {
      mini-ai.enable = true;
      treesitter = {
        enable = true;
        # Grammar packages will be enabled on a language by language basis
        grammarPackages = [];
        settings = {
          highlight.enable = true;
          indent.enable = true;
          autoLoad = true;
          incremental_selection.enable = true;
        };
      };
      treesitter-context = {
        enable = true;
        settings = {
          min_window_height = 40;
        };
      };
      # tpope's indent fixes
      sleuth.enable = true;
    };
    autoCmd = [
      {
        desc = "Notify missing grammars";
        event = "BufEnter";
        callback = let
          registered-languages = builtins.listToAttrs (map (p: {
              name = p;
              value = true;
            }) (map (p: p.language) config.plugins.treesitter.grammarPackages
              ++ [
                "markdown"
                "c"
                "lua"
                "vimscript"
                "vimdoc"
              ]
              ++ config.theovim.syntax-highlight.ignore-ft));
        in
          mkRaw # lua
          
          ''
            function(context)
            local ft = vim.api.nvim_get_option_value("filetype", {scope = "local", buf = context.buf})
            if ft == nil or ft == "" then return end
            local path = vim.api.nvim_buf_get_name(context.buf)
            if path == nil or path == "" then return end
            local lang = vim.treesitter.language.get_lang(ft)
            local __theovim_grammarPackages = ${toLuaObject registered-languages}
            if __theovim_grammarPackages[lang] ~= nil then return end
            vim.notify("Opened a buffer without treesitter highlighting, missing lang or filetype: " .. lang)
            end
          '';
      }
    ];
  };
}
