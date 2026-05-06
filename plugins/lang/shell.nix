{
  lib,
  pkgs,
  config,
  ...
}: let
  formatter = [
    "shellcheck"
    "shellharden"
    "shfmt"
  ];
in
  with lib; {
    options.theovim.lang.shell.enable = mkEnableOption "Enable shell language support";
    config =
      mkIf config.theovim.lang.shell.enable
      {
        lsp.servers.bashls.enable = true;
        plugins = {
          conform-nvim.settings = {
            formatters_by_ft = {
              bash = formatter;
              sh = formatter;
              zsh = formatter;
            };
            formatters = {
              shellcheck = {
                command = lib.getExe pkgs.shellcheck;
              };
              shfmt = {
                command = lib.getExe pkgs.shfmt;
              };
              shellharden = {
                command = lib.getExe pkgs.shellharden;
              };
            };
          };
          treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [bash];
        };
      };
  }
