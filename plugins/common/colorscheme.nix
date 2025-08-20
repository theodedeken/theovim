{config, ...}: {
  colorschemes = {
    catppuccin = {
      enable = false;
      settings = {
        flavor = "mocha";
        italic = true;
        bold = true;
      };
    };
  };

  colorschemes.tokyonight = {
    enable = true;
    settings = {
      style = "storm";
      styles = {
        comments.italic = true;
        functions.bold = true;
        keywords.bold = true;
        #   functions.italic = false;
        #   variables.italic = true;
        #   keywords = {
        #     italic = true;
        #   };
      };
    };
  };
  colorschemes.base16 = {
    enable = false;
    # Bearded-Arc
    colorscheme = {
      base00 = "#1c2433";
      base01 = "#262e3d";
      base02 = "#303847";
      base03 = "#444c5b";
      base04 = "#a1adb7";
      base05 = "#c3cfd9";
      base06 = "#ABB7C1";
      base07 = "#08bdba";
      base08 = "#FF738A";
      base09 = "#FF955C";
      base0A = "#EACD61";
      base0B = "#3CEC85";
      base0C = "#77aed7";
      base0D = "#69C3FF";
      base0E = "#22ECDB";
      base0F = "#B78AFF";
    };
  };
}
