{self, ...}: {
  flake.overlays.default = final: prev: {
    theovim = self.packages.${prev.stdenv.hostPlatform.system}.default;
    inherit (self.packages.${prev.stdenv.hostPlatform.system}) theovim-devcontainer;
  };
}
