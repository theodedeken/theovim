{
  flake,
  inputs',
  self',
  pkgs,
  config,
  ...
}: let
  mkNixvim = module:
    inputs'.nixvim.legacyPackages.makeNixvimWithModule {
      extraSpecialArgs = {inherit inputs self;};
      inherit module;
    };
  inherit (flake) inputs self;
  bareModules = [
    # Core functionality and improvements
    self.nvixPlugins.common
    self.nvixPlugins.buffer
    self.nvixPlugins.ux # better user experience
    self.nvixPlugins.snacks
  ];
  coreModules =
    bareModules
    ++ [
      # Git and version control
      self.nvixPlugins.git

      # UI and appearance
      self.nvixPlugins.lualine
      self.nvixPlugins.explorer
      self.nvixPlugins.firenvim

      # Code editing and syntax
      self.nvixPlugins.treesitter
      self.nvixPlugins.blink-cmp
      self.nvixPlugins.lang
      self.nvixPlugins.lsp
      self.nvixPlugins.dap
      self.nvixPlugins.navigation

      # Productivity
      self.nvixPlugins.autosession
      self.nvixPlugins.ai

      # Dashboard (Auto session works so rarely i see this.)
      self.nvixPlugins.dashboard
    ];
  fullModules =
    coreModules
    ++ [
      self.nvixPlugins.tex
    ];
in {
  packages = rec {
    default = (pkgs.callPackage ./theovim.nix {core = self'.packages.core;}).override {extend = {};};
    theovim = default;
    bare = mkNixvim bareModules;
    core = mkNixvim coreModules;
    full = mkNixvim fullModules;
  };
}
