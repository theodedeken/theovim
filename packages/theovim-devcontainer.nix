{
  core,
  devcontainer,
  writeShellScriptBin,
  extend ? null,
  ...
}: let
  nvim =
    if isNull extend
    then core.extend {}
    else core.extend extend;
in
  writeShellScriptBin "theovim-devcontainer" ''
    set -e

    remove_flag=""
    if [ "$2" = "--rebuild" ]; then
        remove_flag="--remove-existing-container"
    fi

    # Start container with /nix mount
    ${devcontainer}/bin/devcontainer up $remove_flag \
      --mount "type=bind,source=/nix,target=/nix" \
      --mount "type=bind,source=$HOME/.config,target=/home-config" \
      --config $1 --workspace-folder .
    # Start theovim
    ${devcontainer}/bin/devcontainer exec --config $1 --workspace-folder . ${nvim}/bin/nvim
  ''
