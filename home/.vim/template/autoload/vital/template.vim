let s:save_cpoptions = &cpoptions
set cpoptions&vim

function! s:_vital_loaded(V) abort
endfunction

function! s:_vital_depends() abort
  return []
endfunction

function! s:_vital_created(module) abort
endfunction


let &cpoptions = s:save_cpoptions
unlet s:save_cpoptions
