{
  lib,
  config,
  ...
}:
with lib; let
  inherit (lib.nixvim) mkRaw toLuaObject;
  inherit (config.nvix.mkKey) wKeyObj;

  ModeKeymaps = types.submodule ({name, ...}: {
    options = {
      key-combo = mkOption {
        internal = true;
        default = name;
        type = types.str;
      };
      description = mkOption {
        type = types.str;
      };
      action = mkOption {
        type = types.either types.str types.strLuaFn;
      };
    };
  });
  KeyGroup = types.submodule ({name, ...}: {
    options = {
      group-prefix = mkOption {
        internal = true;
        default = name;
        type = types.str;
      };
      icon = mkOption {
        type = types.str;
      };
      name = mkOption {
        type = types.str;
      };
    };
  });
  # Convert theovim keymaps to nixvim keymaps
  to-keymap-config = keymaps:
    lib.pipe keymaps [
      (
        builtins.mapAttrs (
          mode: keymap-configs:
            builtins.map (keymap-config: {
              inherit mode;
              inherit (keymap-config) action;
              key = keymap-config.key-combo;
              options = {
                desc = keymap-config.description;
                silent = true;
                noremap = true;
                remap = true;
              };
            }) (builtins.attrValues keymap-configs)
        )
      )
      builtins.attrValues
      builtins.concatLists
    ];
in {
  options = {
    theovim = {
      keymaps = mkOption {
        type = types.attrsOf (types.attrsOf (types.attrsOf ModeKeymaps));
        default = {};
      };
      keygroups = mkOption {
        type = types.attrsOf KeyGroup;
        default = {};
      };
    };
  };
  config = {
    # TODO: straight to which key
    wKeyList = builtins.map (c: wKeyObj [c.group-prefix c.icon c.name]) (builtins.attrValues config.theovim.keygroups);
    keymaps =
      to-keymap-config config.theovim.keymaps.global;
    autoCmd =
      builtins.attrValues
      (builtins.mapAttrs (
          ft: keymaps: {
            callback =
              mkRaw
              # lua
              ''
                function()
                  vim.schedule(function()
                    -- Adapted from https://github.com/nix-community/nixvim/blob/main/modules/keymaps.nix
                    local __theovim_binds = ${toLuaObject (to-keymap-config keymaps)}
                    for i, map in ipairs(__theovim_binds) do
                      map.options.buffer = true
                      vim.keymap.set(map.mode, map.key, map.action, map.options)
                    end
                  end)
                end
              '';
            event = "FileType";
            pattern = ft;
          }
        )
        (lib.filterAttrs (key: _: key != "global") config.theovim.keymaps));
  };
}
