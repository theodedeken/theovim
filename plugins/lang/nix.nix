{
  plugins = {
    lsp.servers = {
      nixd = {
        enable = true;
        settings.formatting.command = ["alejandra"];
      };
      statix.enable = true;
    };
  };
}
