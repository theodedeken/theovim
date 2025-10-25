{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib.nixvim) mkRaw;
in
  with lib; {
    options = {
      theovim.lang.java.enable = mkEnableOption "Enable Java language support";
    };
    config = mkIf config.theovim.lang.java.enable {
      # LSP + DAP
      plugins.jdtls = {
        enable = true;
        # taken from lazyvim
        luaConfig.pre =
          # lua
          ''
            local jdtls_opts = {
              root_dir = function(path)
                return vim.fs.root(path, vim.lsp.config.jdtls.root_markers)
              end,

              -- How to find the project name for a given root dir.
              project_name = function(root_dir)
                return root_dir and vim.fs.basename(root_dir)
              end,

              -- Where are the config and workspace dirs for a project?
              jdtls_config_dir = function(project_name)
                return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/config"
              end,
              jdtls_workspace_dir = function(project_name)
                return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/workspace"
              end,

              -- Extra jars to load at startup
              bundles = function()
                local bundles = {
                  vim.fn.glob("${pkgs.vscode-extensions.vscjava.vscode-java-debug}/share/vscode/extensions/vscjava.vscode-java-debug/server/*.jar", 1)
                }

                local java_test_bundles = vim.split(vim.fn.glob("${pkgs.vscode-extensions.vscjava.vscode-java-test}/share/vscode/extensions/vscjava.vscode-java-test/server/*.jar", 1), "\n")
                local excluded = {
                  "com.microsoft.java.test.runner-jar-with-dependencies.jar",
                  "jacocoagent.jar",
                }
                for _, java_test_jar in ipairs(java_test_bundles) do
                  local fname = vim.fn.fnamemodify(java_test_jar, ":t")
                  if not vim.tbl_contains(excluded, fname) then
                    table.insert(bundles, java_test_jar)
                  end
                end
                return bundles
              end
            }
          '';
        settings = {
          cmd = [
            "jdtls"
            "-config"
            (mkRaw "jdtls_opts.jdtls_config_dir(jdtls_opts.project_name(jdtls_opts.root_dir(vim.api.nvim_buf_get_name(0))))")
            "-data"
            (mkRaw "jdtls_opts.jdtls_workspace_dir(jdtls_opts.project_name(jdtls_opts.root_dir(vim.api.nvim_buf_get_name(0))))")
          ];
          # Load the debug and java test plugin from the vscode extensions
          init_options.bundles = mkRaw "jdtls_opts.bundles()";
          settings = {
            java = {
              inlayHints = {
                parameterNames = {
                  enabled = "all";
                };
              };
            };
          };
        };
      };
      theovim.keymaps.java.n = {
        "<leader>tm" = {
          action = mkRaw "require'jdtls'.test_nearest_method";
          description = "Test the nearest method";
        };
        "<leader>tc" = {
          action = mkRaw "require'jdtls'.test_class";
          description = "Test this class";
        };
      };
      theovim.keygroups."<leader>t" = {
        icon = "󰙨";
        name = "test";
      };
      # Formatting
      extraPackages = [pkgs.google-java-format];
      plugins.conform-nvim.settings = {
        formatters_by_ft.java = ["google-java-format"];
        formatters.google-java-format = {
          command = "google-java-format";
        };
      };
    };
  }
