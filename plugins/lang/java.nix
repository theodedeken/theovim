{
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
      settings.cmd = ["jdtls"];
    };
  };
}
