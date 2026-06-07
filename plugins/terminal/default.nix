{
  plugins.toggleterm = {
    enable = true;
  };
  theovim.syntax-highlight.ignore-ft = ["toggleterm"];
  theovim.keymaps.global.n = {
    "<A-t>" = {
      action = ":ToggleTerm direction=horizontal name=main size=24<CR>";
      description = "Toggle terminal on the bottom";
    };
    "<A-T>" = {
      action = ":ToggleTerm direction=vertical name=main size=80<CR>";
      description = "Toggle terminal on the side";
    };
    # Special gf/gF mapping which open the file under cursor in the window above
    # Otherwise the terminal window would be closed
    "-gf" = {
      action = "mm<C-w>s<C-w>K<C-w>j:q<CR>`mgf";
      description = "Go to file in above window";
    };
    "-gF" = {
      action = "mm<C-w>s<C-w>K<C-w>j:q<CR>`mgF";
      description = "Go to file and location in above window";
    };
    "|gf" = {
      action = "mm<C-w>v<C-w>H<C-w>l:q<CR>`mgf";
      description = "Go to file in left window";
    };
    "|gF" = {
      action = "mm<C-w>v<C-w>H<C-w>l:q<CR>`mgF";
      description = "Go to file and location in left window";
    };
  };
}
