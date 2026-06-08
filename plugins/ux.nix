{
  plugins = {
    # Show screensaver with current directory
    dir-saver.enable = true;
    colorizer = {
      enable = true;
      settings = {
        filetypes = {
          __unkeyed = "*";
        };
        user_default_options = {
          names = true;
          RRGGBBAA = true;
          AARRGGBB = true;
          rgb_fn = true;
          hsl_fn = true;
          css = true;
          css_fn = true;
          tailwind = true;
          mode = "virtualtext";
          virtualtext = "■";
          always_update = true;
        };
      };
    };
    dressing = {
      enable = true;
      settings.input.mappings.n = {
        "q" = "Close";
        "k" = "HistoryPrev";
        "j" = "HistoryNext";
      };
    };
    lastplace.enable = true;
    fidget = {
      enable = true;
      settings = {
        progress.display.progress_icon = ["moon"];
        notification.window = {
          relative = "editor";
          winblend = 0;
          border = "none";
        };
      };
    };
    noice = {
      enable = true;
      settings = {
        presets.bottom_search = true;
        views = {
          cmdline_popup = {
            position = {
              row = -2;
              col = "50%";
            };
          };
          cmdline_popupmenu.position = {
            row = -5;
            col = "50%";
          };
        };

        lsp = {
          override = {
            "vim.lsp.util.convert_input_to_markdown_lines" = true;
            "vim.lsp.util.stylize_markdown" = true;
          };
          hover.enabled = false;
          message.enabled = false;
          signature.enabled = false;
          progress.enabled = false;
        };
      };
    };
  };
}
