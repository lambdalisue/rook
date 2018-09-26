function! s:_vital_depends() abort
  return []
endfunction

function! s:_vital_loaded(V) abort
  call map(
        \ copy(s:_vital_depends()),
        \ { _, v -> extend(s:, { split(v, '\.')[-1]: a:V.import(v) }) }
        \)
endfunction

function! s:_vital_created(module) abort
endfunction
