if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1
let g:vimsyn_folding='af'

setl tabstop=8
setl softtabstop=2
setl shiftwidth=2
setl smarttab
setl expandtab

setl autoindent
setl smartindent
setl foldmethod=syntax

setl textwidth=0
if exists('&colorcolumn')
  setl colorcolumn=79
endif

" Automatically insert / for second line
nnoremap <buffer><expr><silent> o
      \ getline('.') =~# '^\s*\\\s*.*' ? 'yypC\ ' : 'o'
inoremap <buffer><expr><silent> <CR>
      \ getline('.') =~# '^\s*\\\s*.*' ? "\<Esc>yypC\\ " : "\<CR>"
