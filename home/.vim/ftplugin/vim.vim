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


" Automatically insert \ when required {{{
function! s:smart_o() abort
  let line = getline('.')
  if line =~# '^\s*\\\s*$'
    " Remove leading indent and \ if the line only contains spaces and \
    let indent = repeat(' ', get(g:, 'vim_indent_cont', 6))
    let pattern = printf('\%%(%s\)\?\\\s*$', indent)
    let leading = substitute(line, pattern, '', '')
    call setline('.', leading)
    call setpos('.', [0, line('.'), len(leading), !empty(leading)])
    startinsert
  else
    let leading = matchstr(line, '^\s*\\\?\s*')
    call append(line('.'), leading)
    call setpos('.', [0, line('.')+1, len(leading), !empty(leading)])
    startinsert
  endif
endfunction
nnoremap <silent><buffer> o :<C-u>call <SID>smart_o()<CR>

function! s:smart_CR_i() abort
  let line = getline('.')
  if line =~# '^\s*\\\s*$'
    return s:smart_o()
  endif
  let leading = matchstr(line, '^\s*\\\?\s*')
  let prefix = line[:col('.')-1]
  let suffix = line[col('.'):]
  call setline('.', prefix)
  call append(line('.'), leading . suffix)
  call setpos('.', [0, line('.')+1, len(leading), !empty(leading)])
  startinsert
endfunction
inoremap <silent><buffer> <CR> <Esc>:<C-u>call <SID>smart_CR_i()<CR>
" }}}
