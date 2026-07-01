{
  core,
  bash,
  devcontainer,
  resholve,
  extend ? null,
  ...
}: let
  nvim-bin =
    if isNull extend
    then core.extend {}
    else core.extend extend;
in
  resholve.writeScriptBin "theovim-devcontainer" {
    inputs = [devcontainer];
    execer = [
      "cannot:${devcontainer}/bin/devcontainer"
    ];
    interpreter = "${bash}/bin/bash";
  }
  # bash
  ''
    set -e

    remove_flag="--remove-existing-container=false"
    if [ "$2" = "--rebuild" ]; then
      remove_flag="--remove-existing-container=true"
    fi

    # Start container with /nix mount
    devcontainer up "$remove_flag" \
      --mount "type=bind,source=/nix,target=/nix" \
      --mount "type=bind,source=$HOME/.config,target=/home-config" \
      --config "$1" --workspace-folder .
    # Start theovim
    devcontainer exec --config "$1" --workspace-folder . "${nvim-bin}"/bin/nvim
  ''
