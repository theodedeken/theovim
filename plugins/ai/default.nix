{lib, ...}: let
  inherit (lib.nixvim) mkRaw;
in {
  plugins.codecompanion = {
    enable = true;
    settings = {
      strategies.chat.adapter = "gemini";
      strategies.inline.adapter = "gemini";
    };
  };

  imports = with builtins;
  with lib;
    map (fn: ./${fn}) (
      filter (fn: (fn != "default.nix" && !hasSuffix ".md" "${fn}")) (attrNames (readDir ./.))
    );
}
