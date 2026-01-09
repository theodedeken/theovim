{
  pkgs,
  lib,
  config,
  ...
}: let
  docker-patched-injections = pkgs.writeText "injections.scm" ''
    ((comment) @injection.content
      (#set! injection.language "comment"))

    ((shell_command) @injection.content
      (#set! injection.language "bash")
      (#set! injection.include-children))

    ((run_instruction
      (heredoc_block) @injection.content)
      (#set! injection.language "bash")
      (#set! injection.include-children))
  '';
in
  with lib; {
    options = {
      theovim.lang.docker.enable = mkEnableOption "Enable dockerfile support";
    };
    config = mkIf config.theovim.lang.docker.enable {
      # FIXME: override until https://github.com/camdencheek/tree-sitter-dockerfile/pull/52 is merged
      extraFiles."queries/dockerfile/injections.scm".source = docker-patched-injections;
    };
  }
