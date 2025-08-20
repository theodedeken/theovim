{
  lib,
  pkgs,
  ...
}: let
  inherit (lib.nixvim) utils mkRaw;
in {
  # Overlays
  nixpkgs.overlays = [
    (final: prev: {
      vimPlugins =
        prev.vimPlugins
        // {
          # HACK: override with my own fork to add resumable option
          snacks-nvim = prev.vimPlugins.snacks-nvim.overrideAttrs (_: {
            version = "2025-07-31";
            src = pkgs.fetchFromGitHub {
              owner = "theodedeken";
              repo = "snacks.nvim";
              rev = "e341f923ea7294dff6d167ecc27a88100c579fae";
              sha256 = "sha256-Uh0QdrFqiUSbOhLiqTKr8BKLXlhu+rStXhQkmyHTsJE=";
              fetchSubmodules = false;
            };
          });
        };
    })
  ];
  # Generalise for all colorschemes
  # <https://github.com/folke/snacks.nvim/discussions/1306#discussioncomment-12266647>

  # TODO: <https://github.com/folke/snacks.nvim/discussions/2003#discussioncomment-13653042>
  # Implement this with a fix, i have done the implementation in nix way, but `grep` seems to break.
  # first check is required if it is from lua or nix
  plugins.todo-comments.enable = true;
  plugins.neoscroll.enable = true;
  plugins.snacks = {
    enable = true;
    settings = {
      bigfile.enabled = true;
      scroll.enabled = false;
      lazygit.config.os.edit =
        mkRaw # lua
        
        ''
          '[ -z "\"$NVIM\"" ] && (nvim -- {{filename}}) || (nvim --server "\"$NVIM\"" --remote-send "\"q\"" && nvim --server "\"$NVIM\"" --remote {{filename}})'
        '';
      quickfile.enabled = true;
      indent.enabled = true;
      words.enabled = true;
      statuscolumn.enabled = true;
      dashboard.enabled = lib.mkDefault false;
      picker = let
        keys = {
          "<c-d>" =
            (utils.listToUnkeyedAttrs ["preview_scroll_down"])
            // {
              mode = "n";
            };
          "<c-u>" =
            (utils.listToUnkeyedAttrs ["preview_scroll_up"])
            // {
              mode = "n";
            };
          "-" =
            (utils.listToUnkeyedAttrs ["edit_split"])
            // {
              mode = "n";
            };
          "|" =
            (utils.listToUnkeyedAttrs ["edit_vsplit"])
            // {
              mode = "n";
            };
        };
      in {
        enabled = true;
        win = {
          input.keys = keys;
          list.keys = keys;
        };
      };
      image = {
        enabled = true;
        border = "none";
        doc.inline = false;
      };
      notifier = {
        enabled = true;
        style = "minimal";
        top_down = false;
      };
    };
  };

  extraPackages = with pkgs; [
    imagemagick
    ghostscript_headless
    tectonic
    mermaid-cli
  ]; # for image support

  autoCmd = [
    {
      desc = "Pre init Function";
      event = ["VimEnter"];
      callback =
        utils.mkRaw # lua
        
        ''
            -- Taken from https://github.com/folke/snacks.nvim?tab=readme-ov-file#-usage
            function()
            -- Setup some globals for debugging (lazy-loaded)
            _G.dd = function (...)
              Snacks.debug.inspect
              (...)
              end
              _G.bt = function()
            Snacks.debug.backtrace()
            end
            vim.print = _G.dd -- Override print to use snacks for `:=` command

            -- Create some toggle mappings
            Snacks.toggle.diagnostics():map("<leader>ud")
            Snacks.toggle.line_number():map("<leader>ul")
            Snacks.toggle.inlay_hints():map("<leader>uh")
            Snacks.toggle.treesitter():map("<leader>uT")
            Snacks.toggle.option("spell",
            { name = "Spelling" }):map("<leader>us")
            Snacks.toggle.option("wrap",
            { name = "Wrap" }):map("<leader>uw")
            Snacks.toggle.option("relativenumber",
            { name = "Relative Number" }):map("<leader>uL")
            Snacks.toggle.option("conceallevel",
            { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
            Snacks.toggle.option("background",
            { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
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
