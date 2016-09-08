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
  CodeMirror.Vim.map("<C-f>", "<Esc>2li", "insert");
  CodeMirror.Vim.map("<C-b>", "<Esc>i", "insert");

  // Map <Nop> otherwise it would trigger browser shortcuts
  CodeMirror.Vim.map("<C-h>", "<Nop>", "normal");
  CodeMirror.Vim.map("<C-l>", "<Nop>", "normal");
  CodeMirror.Vim.map("<C-w>", "<Nop>", "normal");
  CodeMirror.Vim.map("<C-t>", "<Nop>", "normal");
  console.log('Custom keymaps are applied.');
});
