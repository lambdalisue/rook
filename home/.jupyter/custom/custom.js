require(['codemirror/keymap/vim'], function() {
  // Use gj/gk instead of j/k
  CodeMirror.Vim.map("j", "gj", "normal");
  CodeMirror.Vim.map("k", "gk", "normal");

  // Use Ctrl-h/l/j/k to move around in Insert mode
  CodeMirror.Vim.map("<C-h>", "<Esc>i", "insert");
  CodeMirror.Vim.map("<C-l>", "<Esc>lli", "insert");
  CodeMirror.Vim.map("<C-j>", "<Esc>ji", "insert");
  CodeMirror.Vim.map("<C-k>", "<Esc>ki", "insert");

  // Use Ctrl-h/l/j/k to move around in Normal mode
  // otherwise it would trigger browser shortcuts
  CodeMirror.Vim.map("<C-h>", "h", "normal");
  CodeMirror.Vim.map("<C-l>", "l", "normal");
  CodeMirror.Vim.map("<C-j>", "j", "normal");
  CodeMirror.Vim.map("<C-k>", "k", "normal");

  console.log('Custom keymaps are applied.');
});
