setl tabstop=8
setl softtabstop=2
setl shiftwidth=2
setl smarttab
setl expandtab

setl autoindent
setl smartindent
setl foldmethod=marker

setl textwidth=0
if exists('&colorcolumn')
  setl colorcolumn=79
endif

setl iskeyword&
setl iskeyword+=:
setl iskeyword+=#

nmap <buffer><silent> <localleader><localleader>s :<C-u>call <SID>source("%")<CR>
function! s:source(filename)
  let filename = expand(a:filename)
  execute 'source ' filename
  redraw | echo printf("'%s' has sourced.", filename)
endfunction
