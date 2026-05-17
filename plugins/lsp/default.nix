{
  lib,
  config,
  ...
}: let
  inherit (config.nvix.mkKey) mkKeymap;
in {
  lsp = {
    inlayHints.enable = true;
    keymaps = [
    ];
    servers = {
      typos_lsp = {
        enable = true;
        config.init_options.diagnosticSeverity = "Hint";
      };
    };
  };
  plugins = {
    otter = {
      enable = false;
      settings.buffers = {
        set_filetype = true;
      };
    };
    # TODO: Add mappings in parallel with quickfix
    trouble.enable = true;
    tiny-inline-diagnostic.enable = true;
    lspconfig.enable = true;
    lspsaga = {
      enable = true;
      settings = {
        lightbulb = {
          enable = false;
          virtualText = false;
        };
        outline.keys.jump = "<cr>";
        ui.border = config.nvix.border;
        scrollPreview = {
          scrollDown = "<c-d>";
          scrollUp = "<c-u>";
        };
      };
    };
  };

  imports = with builtins;
  with lib;
    map (fn: ./${fn}) (
      filter (fn: (fn != "default.nix" && !hasSuffix ".md" "${fn}")) (attrNames (readDir ./.))
    );
}
