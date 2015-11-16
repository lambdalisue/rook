if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

setl tabstop=8
setl softtabstop=2
setl shiftwidth=2
setl smarttab
setl expandtab

setl autoindent
setl smartindent
setl foldmethod=indent

setl textwidth=0
if exists('&colorcolumn')
  setl colorcolumn=79
endif

" css use hyphen(-) often in id/class name
setl iskeyword&
setl iskeyword+=-
