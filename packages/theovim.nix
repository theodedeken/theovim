{
  writeShellScriptBin,
  core,
  extend ? null,
  ...
}: let
  nvim =
    if isNull extend
    then core.extend {}
    else core.extend extend;
in
  writeShellScriptBin "theovim" ''
    ${nvim}/bin/nvim
  ''
