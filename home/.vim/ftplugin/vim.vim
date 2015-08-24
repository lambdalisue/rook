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

function! s:source(filename) abort
  let filename = expand(a:filename)
  execute 'source ' filename
  redraw | echo printf("'%s' has sourced.", filename)
endfunction
nnoremap <buffer> [reload_rc] <Nop>
nmap <buffer> <LocalLeader><LocalLeader>s [reload_rc]
nnoremap <buffer><silent> [reload_rc] :<C-u>call <SID>source('%')<CR>
