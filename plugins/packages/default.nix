{
  nixpkgs.overlays = [
    (final: prev: {
      vimPlugins =
        prev.vimPlugins
        // {
          # FIXME: remove once vim coach is packaged in nix
          vim-coach = prev.callPackage ./vim-coach-package.nix {
            inherit
              (prev.vimUtils)
              buildVimPlugin
              ;
          };
          # FIXME: remove once flirt is packaged in nix
          flirt = prev.callPackage ./flirt.nix {
            inherit
              (prev.vimUtils)
              buildVimPlugin
              ;
          };
        };
    })
  ];
}
