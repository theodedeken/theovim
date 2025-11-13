{config, ...}: {
  theovim.keymaps.global.n."<leader>lw" = {
    action = "<cmd>:lua Snacks.picker.diagnostics()<cr>";
    description = "Show workspace diagnostics";
  };
  diagnostic.settings = {
    virtual_text = false;
    underline = true;
    signs = true;
    severity_sort = true;
    float = {
      border = config.nvix.border;
      source = "always";
      focusable = false;
    };
  };
}
