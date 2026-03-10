{
  theovim,
  jq,
  devcontainer,
  writeText,
  writeShellScript,
  writeShellScriptBin,
  extend ? null,
  ...
}: let
  theovim-extend =
    if isNull extend
    then theovim
    else theovim.override {inherit extend;};
  # build devcontainer and extract name
  # build extra docker image with nix layer and same name
  # start devcontainer
  # nix-docker =
  #   writeText "Dockerfile"
  #   # dockerfile
  #   ''
  #     ARG DEVCONTAINER
  #     FROM $DEVCONTAINER
  #     RUN sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --no-daemon --yes
  #   '';
  #
  # nix-conf = writeText "nix.conf" ''
  #   extra-substituters = file:///parent-nix/store
  #   experimental-features = nix-command flakes
  # '';
  # Installs nix in the devcontainer
  init-devcontainer =
    writeShellScript "init-devcontainer"
    # bash
    ''
      if test -L "$HOME/.config/zellij"; then
        echo config already linked
      else
        sudo ln -s /home-config/zellij $HOME/.config/zellij
      fi
    '';
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
    ${devcontainer}/bin/devcontainer exec --config $1 --workspace-folder . ${init-devcontainer}
    # Start theovim
    ${devcontainer}/bin/devcontainer exec --config $1 --workspace-folder . ${theovim-extend}/bin/theovim
  ''
