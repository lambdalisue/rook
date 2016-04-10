scriptencoding utf-8

augroup MyAutoCmdForDein
  autocmd! *
augroup END

function! s:is_git_available()
  if !executable('git')
    return 0
  endif
  if dein#is_sourced('vim-gita')
    return gita#is_enabled()
  elseif dein#is_sourced('vimproc')
    call vimproc#system('git rev-parse')
    return (vimproc#get_last_status() == 0) ? 1 : 0
  else
    call system('git rev-parse')
    return (v:shell_error == 0) ? 1 : 0
  endif
endfunction

function! s:register_on_source_hook(...) abort
  let fname = get(a:000, 0, printf(
        \ 's:%s_on_source',
        \ substitute(g:dein#name, '[-.]', '_', 'g'),
        \))
  execute printf(
        \ 'autocmd MyAutoCmdForDein User dein#source#%s call %s()',
        \ g:dein#name, fname,
        \)
endfunction

" Fundemental ----------------------------------------------------------------
if dein#tap('vim-template') " {{{
  function! s:template_call() abort
    " evaluate {CODE} in <%={CODE}=> and replace
    silent %s/<%=\(.\{-}\)%>/\=eval(submatch(1))/ge
    " move the cursor into <+CURSOR+>
    if search('<+CURSOR+>', 'cw')
      silent execute 'normal! "_da>'
    endif
  endfunction
  autocmd MyAutoCmdForDein User plugin-template-loaded call s:template_call()
endif " }}}

" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker
