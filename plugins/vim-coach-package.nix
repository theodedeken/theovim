{
  buildVimPlugin,
  fetchFromGitHub,
  vimPlugins,
}:
buildVimPlugin {
  pname = "vim-coach.nvim";
  version = "2025-07-16";
  dependencies = [vimPlugins.snacks-nvim];
  src = fetchFromGitHub {
    owner = "shahshlok";
    repo = "vim-coach.nvim";
    rev = "ed31e7b9450691199288180a922d8166ae11a0b9";
    sha256 = "sha256-9Nnlghnor8wKKY4ETwNtGFjv1BUW64EWDKhRJJSj0pk=";
  };
  meta.homepage = "https://github.com/shahshlok/vim-coach.nvim/";
}
