let s:save_cpoptions = &cpoptions
set cpoptions&vim

function! s:_vital_loaded(V) abort
  let s:Dict = a:V.import('Data.Dict')
  let s:config = {}
endfunction
function! s:_vital_depends() abort
  return [
        \ 'Data.Dict',
        \]
endfunction
function! s:_vital_created(module) abort
endfunction

function! s:_throw(msg) abort
  throw 'vital: XXXXX: ' . a:msg
endfunction

function! s:get_config() abort
  return copy(s:config)
endfunction
function! s:set_config(config) abort
  call extend(s:config, s:Dict.pick(a:config, [
        \]))
endfunction

let &cpoptions = s:save_cpoptions
unlet s:save_cpoptions
