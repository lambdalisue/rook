let s:file = expand('<sfile>:p')
let s:root = fnamemodify(s:file, ':h')
let s:is_windows = has('win16') || has('win32') || has('win64')
let s:separator = s:is_windows && !&shellslash ? '\' : '/'

" Source Vim's vimrc
execute printf('source %s', fnameescape(s:root . s:separator . 'vimrc'))

" Neovim-qt GUI font
if has('gui_running')
  command -nargs=? Guifont call rpcnotify(0, 'Gui', 'SetFont', "<args>") |
        \ let g:Guifont = "<args>"
  Guifont RictyForPowerline 9
endif

