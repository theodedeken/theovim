{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  options = {
    theovim.lang.java.enable = mkEnableOption "Enable Java language support";
  };
  config = mkIf config.theovim.lang.java.enable {
    plugins.jdtls = {
      enable = true;
      settings.cmd = [
        "jdtls"
        # Cache data
        {
          __raw = "'-data='..os.getenv('HOME')..'.cache/jdtls'";
        }
      ];
    };
    extraPackages = [pkgs.google-java-format];
    plugins.conform-nvim.settings = {
      formatters_by_ft.java = ["google-java-format"];
      formatters.google-java-format = {
        command = "google-java-format";
      };
    };
  };
}
