{
  buildVimPlugin,
  fetchFromGitHub,
}:
buildVimPlugin {
  pname = "flirt.nvim";
  version = "2025-08-17";
  src = fetchFromGitHub {
    owner = "tamton-aquib";
    repo = "flirt.nvim";
    rev = "7726d8cbe8b3179c23cb14214b150e235ed846ed";
    sha256 = "sha256-aKaRIlbUf9cbgL0Km8YNcQrmCGaxERMcTIeFuEPnvO0=";
  };
  meta.homepage = "https://github.com/tamton-aquib/flirt.nvim";
}
