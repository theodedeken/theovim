{
  inputs,
  self,
  ...
}: {
  flake.overlays.default = final: prev: {
    stable = import inputs.nixpkgs-stable {
      allowUnfree = true;
      inherit (prev.stdenv.hostPlatform) system;
      overlays = prev.lib.attrValues self.overlays;
    };
    theovim = self.packages.${prev.stdenv.hostPlatform.system}.default;
  };
}
