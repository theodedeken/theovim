{lib, ...}: {
  plugins = {
    copilot-lua = {
      enable = false;
      settings = {
        filetypes.markdown = true;
        suggestion = {
          enabled = true;
          auto_trigger = true;
        };
      };
    };
    copilot-chat = {
      enable = false;
      settings = {
        window = {
          border = "rounded";
          layout = "float";
          width = 0.5;
          height = 0.6;
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
