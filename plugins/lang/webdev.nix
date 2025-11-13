{
  lib,
  config,
  ...
}: let
  inherit (config.nvix.mkKey) wKeyObj;
in
  with lib; {
    options = {
      theovim.lang.webdev.enable = mkEnableOption "Enable web development";
    };
    config = mkIf config.theovim.lang.webdev.enable {
      wKeyList = [
        (wKeyObj ["<leader>R" "󱞒" "Http Requests"])
      ];
      plugins = {
        kulala = {
          enable = true; # for rest api (alter to insomnia and postman)
          luaConfig.post =
            # lua
            ''
              require("kulala").setup({
                  global_keymaps = true;
                  global_keymaps_prefix = "<leader>R";
                  kulala_keymaps_prefix = "";
                  })
            '';
          lazyLoad = {
            enable = true;
            settings = {
              ft = [
                "http"
                "rest"
              ];
            };
          };
        };
        ts-autotag.enable = true;
        ts-comments.enable = true;
        lsp.servers = {
          ts_ls.enable = true;
          tailwindcss.enable = true;
          svelte.enable = true;
          html.enable = true;
          eslint.enable = true;
          emmet_ls.enable = true;
          cssls.enable = true;
          biome.enable = true;
        };
      };
    };
  }
