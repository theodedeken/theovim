{
  description = "A nixvim configuration";
  # TODO: work on startup time
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixvim.url = "github:nix-community/nixvim";
    flake-parts.url = "github:hercules-ci/flake-parts";

    buffer-manager = {
      url = "github:j-morano/buffer_manager.nvim";
      flake = false;
    };

    tokyodark = {
      url = "github:tiagovla/tokyodark.nvim";
      flake = false;
    };

    md-pdf = {
      url = "github:arminveres/md-pdf.nvim";
      flake = false;
    };
  };

  outputs = {
    self,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      perSystem = {
        pkgs,
        config,
        system,
        ...
      }: {
        devShells.default = pkgs.mkShell {
          name = "nvix";
          packages = with pkgs; [
            # Nix lsp
            nixd
            # Nix code formatter
            alejandra
            # Nvix itself
            self.packages.${system}.default
          ];
          shellHook = ''
            echo 1>&2 "🐼: $(id -un) | 🧬: $(nix eval --raw --impure --expr 'builtins.currentSystem') | 🐧: $(uname -r) "
            echo 1>&2 "Ready to work on nvix!"
          '';
        };
      };
      imports = [
        ./modules
        ./default.nix

        inputs.flake-parts.flakeModules.easyOverlay
      ];
    };
}
