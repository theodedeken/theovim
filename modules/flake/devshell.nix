{
  perSystem = {
    pkgs,
    system,
    self',
    ...
  }: {
    devShells.default = pkgs.mkShell rec {
      name = "nvix";
      meta.description = "Dev environment for nixvim-config";
      packages = with pkgs; [
        nixd
        self'.packages.default
      ];
      shellHook = ''
        echo 1>&2 "🐼: $(id -un) | 🧬: $(nix eval --raw --impure --expr 'builtins.currentSystem') | 🐧: $(uname -r) "
        echo 1>&2 "Ready to work on ${name}!"
      '';
    };
  };
}
