# Explorer Module

This module integrates powerful file exploration plugins into your Neovim setup.

---

## 🛠️ Usage

To enable the explorer, configure it in your Nix setup by setting the appropriate option:

### General Configuration

```nix
# Add to your Nix configuration
modules.imports = [
  inputs.nvix.nvixModules.utils
  inputs.nvix.nvixModules.explorer
];
```

> **Note:** The `utils` module is required to ensure functionality.

---

## 🔑 Features

- Seamless integration with popular file explorer plugins.

---

## 🔑 Keybindings

| Keybinding | Action              | Explorer  |
|------------|---------------------|-----------|
| `<leader>e`| Open File Explorer  | Snacks    |

---

## 📋 Plugin-Specific Details
