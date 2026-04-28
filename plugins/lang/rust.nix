{
  lib,
  config,
  ...
}:
with lib; {
  options.theovim.lang.rust.enable = mkEnableOption "Enable rust language support";
  config =
    mkIf config.theovim.lang.rust.enable
    {
      plugins = {
        rustaceanvim.enable = true;
        crates.enable = true;
      };
    };
}
