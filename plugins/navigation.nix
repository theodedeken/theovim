# Neovim navigation
{lib, ...}: let
  inherit (lib.nixvim) mkRaw;
in {
  # file picker
  theovim.keymaps.global.n."<C-p>" = {
    action = mkRaw ''
      function()
        Snacks.picker.files({
          matcher = {frecency=true},
          hidden = true,
          layout = "vscode"
        })
      end
    '';
    description = "Pick a file";
  };
}
