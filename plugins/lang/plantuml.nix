{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib.nixvim) mkRaw;
  treesitter-plantuml-grammar =
    (pkgs.tree-sitter.buildGrammar {
      language = "plantuml";
      version = "1.0.0";
      src = pkgs.fetchFromGitHub {
        owner = "Decodetalkers";
        repo = "tree_sitter_plantuml";
        rev = "c7361a1d481dc1ff6700b14ea1d5efc549b72713";
        hash = "sha256-DtCaYfHB95uPIHDR2OmR8K7HU6V89g877BGVphrY9So=";
      };
      generate = true;
      meta.homepage = "https://github.com/Decodetalkers/tree_sitter_plantuml";
    }).overrideAttrs
    (drv: {
      # Broken regex in source
      patchPhase = ''
        sed -i '99d' grammar.js
      '';
      # Move queries to correct place
      fixupPhase = ''
        mkdir -p $out/queries/plantuml
        mv test/queries/*.scm $out/queries/plantuml/
      '';
    });
in
  with lib; {
    options = {
      theovim.lang.plantuml.enable = mkEnableOption "Enable plantuml language support";
    };
    config = mkIf config.theovim.lang.plantuml.enable {
      plugins = {
        treesitter = {
          grammarPackages = [treesitter-plantuml-grammar];
          languageRegister.plantuml = "plantuml";
        };
      };

      extraPlugins = [
        treesitter-plantuml-grammar
      ];

      plugins.markdown-preview = {
        # Use locally hosted plantuml server
        settings.preview_options.uml = mkRaw "{server = 'http://127.0.0.1:8301/plantuml'}";
      };
      filetype.extension = {
        plantuml = "plantuml";
        puml = "plantuml";
      };
    };
  }
