let s:menus = {}

let s:menus.shortcut = {
      \ 'description': 'Shortcut menu'
      \}
let s:menus.shortcut.file_candidates = [
      \ ['~/.homesick/repos/rook', '~/.homesick/repos/rook'],
      \ ['~/.vimrc.local', '~/.vimrc.local'],
      \ ['~/.gvimrc.local', '~/.gvimrc.local'],
      \ ['~/.vim/vimrc', '~/.vim/vimrc'],
      \ ['~/.vim/vimrc', '~/.vim/gvimrc'],
      \ ['~/.vim/vimrc.min', '~/.vim/vimrc.min'],
      \ ['~/.vim/filetype.min', '~/.vim/filetype.min'],
      \ ['~/.vim/rc/dein.toml', '~/.vim/rc/dein.toml'],
      \ ['~/.vim/rc/unite.vim', '~/.vim/rc/unite.vim'],
      \ ['~/.vim/rc/vimfiler.vim', '~/.vim/rc/vimfiler.vim'],
      \ ['~/.vim/rc/vimshell.vim', '~/.vim/rc/vimshell.vim'],
      \ ['~/.vim/rc/lightline.vim', '~/.vim/rc/lightline.vim'],
      \ ['~/.vim/ftplugin/', '~/.vim/ftplugin/'],
      \ ['~/.vim/syntax/', '~/.vim/syntax/'],
      \ ['~/.vim/template/', '~/.vim/template/'],
      \ ['~/.vim/template/', '~/.vim/init.vim'],
      \ ['~/.vim/ginit.vim', '~/.vim/ginit.vim'],
      \ ['https://raw.githubusercontent.com/codemirror/CodeMirror/HEAD/keymap/vim.js', 'https://raw.githubusercontent.com/codemirror/CodeMirror/HEAD/keymap/vim.js'], 
      \]
call denite#custom#var('menu', 'menus', s:menus)
