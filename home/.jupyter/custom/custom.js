require(['codemirror/keymap/vim'], function() {
  // Use gj/gk instead of j/k
  CodeMirror.Vim.map("j", "gj", "normal");
  CodeMirror.Vim.map("k", "gk", "normal");
});
