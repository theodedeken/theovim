{
  lib,
  config,
  ...
}: let
in
  with lib; {
    options = {
      theovim.lang.gitlab-ci.enable = mkEnableOption "Enable Gitlab CI support";
    };
    config = mkIf config.theovim.lang.gitlab-ci.enable {
      theovim.lang.yaml.enable = true;
      lsp.servers = {
        gitlab_ci_ls.enable = true;
      };
      plugins = {
      };
      filetype.pattern = {
        ".*%.gitlab%-ci%.ya?ml" = "yaml.gitlab";
      };
    };
  }
