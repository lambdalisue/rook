require([
  'codemirror/keymap/vim',
  'nbextensions/vim_binding/vim_binding'
], function() {
  // Use ; as : in normal/visual mode
  CodeMirror.Vim.map(";", ":", "normal");
  CodeMirror.Vim.map(";", ":", "visual");

  // Use gj/gk instead of j/k
  CodeMirror.Vim.map("j", "<Plug>(vim-binding-gj)", "normal");
  CodeMirror.Vim.map("k", "<Plug>(vim-binding-gk)", "normal");
  CodeMirror.Vim.map("gj", "<Plug>(vim-binding-j)", "normal");
  CodeMirror.Vim.map("gk", "<Plug>(vim-binding-k)", "normal");

  // Emacs like binding
  CodeMirror.Vim.map("<C-a>", "<Esc>^i", "insert");
  CodeMirror.Vim.map("<C-e>", "<Esc>$a", "insert");
  CodeMirror.Vim.map("<C-f>", "<Esc>lwi", "insert");
  CodeMirror.Vim.map("<C-b>", "<Esc>lbi", "insert");
  CodeMirror.Vim.map("<C-d>", "<Esc>lxi", "insert");
  CodeMirror.Vim.map("<C-h>", "<BS>", "insert");
  CodeMirror.Vim.map("<C-m>", "<CR>", "insert");
  CodeMirror.Vim.map("<C-i>", "<Tab>", "insert");

  console.log('Custom keymaps are applied.');
});
