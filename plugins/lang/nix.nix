{pkgs, ...}: {
  extraPackages = [pkgs.alejandra];
  plugins = {
    lsp.servers = {
      nixd = {
        enable = true;
      };
      statix.enable = true;

    };
      conform-nvim.settings = {
        formatters_by_ft.nix = ["alejandra"];
        formatters.alejandra = {
          command = "alejandra";
        };
      };
  };
}
