require([
  'base/js/namespace',
  'notebook/js/cell',
  'codemirror/addon/edit/trailingspace'
], function(ns, cell) {
  var cm_config = cell.Cell.options_default.cm_config;
  cm_config.showTrailingSpace = true;

  ns.notebook.get_cells().map(function(cell) {
    var cm = cell.code_mirror;
    if (cm) {
      cm.setOption('showTrailingSpace', true);
    }
  });
});

require([
  'codemirror/keymap/vim',
  'vim_binding/vim_binding'
], function() {
  // Use gj/gk instead of j/k
  CodeMirror.Vim.map("j", "gj", "normal");
  CodeMirror.Vim.map("k", "gk", "normal");

  // Use Ctrl-h/l/j/k to move around in Insert mode
  CodeMirror.Vim.defineAction('[i]<C-h>', function(cm) {
    var head = cm.getCursor();
    CodeMirror.Vim.handleKey(cm, '<Esc>');
    if (head.ch <= 1) {
      CodeMirror.Vim.handleKey(cm, 'i');
    } else {
      CodeMirror.Vim.handleKey(cm, 'h');
      CodeMirror.Vim.handleKey(cm, 'a');
    }
  });
  CodeMirror.Vim.defineAction('[i]<C-l>', function(cm) {
    var head = cm.getCursor();
    CodeMirror.Vim.handleKey(cm, '<Esc>');
    if (head.ch === 0) {
      CodeMirror.Vim.handleKey(cm, 'a');
    } else {
      CodeMirror.Vim.handleKey(cm, 'l');
      CodeMirror.Vim.handleKey(cm, 'a');
    }
  });
  CodeMirror.Vim.mapCommand("<C-h>", "action", "[i]<C-h>", {}, { "context": "insert" });
  CodeMirror.Vim.mapCommand("<C-l>", "action", "[i]<C-l>", {}, { "context": "insert" });
  CodeMirror.Vim.map("<C-j>", "<Esc>ja", "insert");
  CodeMirror.Vim.map("<C-k>", "<Esc>ka", "insert");

  // Use Ctrl-h/l/j/k to move around in Normal mode
  // otherwise it would trigger browser shortcuts
  CodeMirror.Vim.map("<C-h>", "h", "normal");
  CodeMirror.Vim.map("<C-l>", "l", "normal");
  CodeMirror.Vim.map("<C-j>", "j", "normal");
  CodeMirror.Vim.map("<C-k>", "k", "normal");

  // Emacs like binding
  CodeMirror.Vim.map("<C-a>", "<Esc>^i", "insert");
  CodeMirror.Vim.map("<C-e>", "<Esc>$a", "insert");
  CodeMirror.Vim.map("<C-f>", "<Esc>lwi", "insert");
  CodeMirror.Vim.map("<C-b>", "<Esc>lbi", "insert");
  CodeMirror.Vim.map("<C-d>", "<Esc>lxi", "insert");

  console.log('Custom keymaps are applied.');
});
