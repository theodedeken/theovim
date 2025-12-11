{lib, ...}: let
  inherit (lib.nixvim.plugins) mkNeovimPlugin;
in
  mkNeovimPlugin {
    name = "onedarkpro-nvim";
    maintainers = [];
    url = "https://github.com/olimorris/onedarkpro.nvim";
    description = "Atom's iconic One Dark theme. Cacheable, fully customisable, Tree-sitter and LSP semantic token support. Comes with variants";
    colorscheme = "vaporwave";
    moduleName = "onedarkpro";
    settingsOptions = {
    };
    isColorscheme = true;
  }
