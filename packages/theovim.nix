{
  writeText,
  writeShellScriptBin,
  core,
  extend ? null,
  ...
}: let
  nvim =
    if builtins.isNull extend
    then core.extend {}
    else core.extend extend;
  layout =
    writeText "layout.kdl"
    # kdl
    ''
      layout {
          pane {
              command "${nvim}/bin/nvim"
              name "Neovim"
              close_on_exit true
          }
          pane size=1 borderless=true {
              plugin location="zellij:compact-bar"
          }
      }
    '';
in
  writeShellScriptBin "theovim" ''
    name=$(basename $PWD)
    # Check if a session named 'main' exists and has 'EXITED' status
    if zellij ls -n 2>&1 | grep -E "^$name .*EXITED" >/dev/null; then
      zellij delete-session $name # delete dead session
    fi
    # Check if a session named 'main' exists (regardless of status)
    if zellij ls -n 2>&1 | grep -E "^$name " >/dev/null; then
      zellij attach $name
    else
      # We don't have a main session yet
      zellij --session $name --new-session-with-layout ${layout}
    fi
  ''
