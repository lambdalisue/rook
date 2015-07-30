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

function! s:Jq(...)
  let fname = get(a:000, 0, '.')
  silent vnew
  silent execute printf('%%!jq "%s", fname)
endfunction
command! -nargs=? Jq call s:Jq(<f-args>)
