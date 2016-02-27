augroup MyAutoCmd
  autocmd!
augroup END

" Improve mkview/loadview {{{
function! s:checkview() abort
  if !&buflisted || &buftype =~# '^\%(nofile\|quickfix\|terminal\)$'
    return 0
  endif
  return 1
endfunction
autocmd MyAutoCmd BufWinLeave * if s:checkview() | silent! mkview   | endif
autocmd MyAutoCmd BufReadPost * if s:checkview() | silent! loadview | endif
" }}}

" Seemless substitution {{{
cnoreabbrev <silent><expr>s getcmdtype() ==# ':' && getcmdline() =~# '^s'
      \ ? "<C-u>%s/<C-r>=get([], getchar(0), '')<CR>"
      \ : 's'
cnoreabbrev <silent><expr>'<,'>s getcmdtype() ==# ':' && getcmdline() =~# "^'<,'>s"
      \ ? "'<,'>s/<C-r>=get([], getchar(0), '')<CR>"
      \ : "'<,'>s"
" }}}

" Reload vimrc with <Leader><Leader>r {{{
if has('vim_starting')
  function s:reload_vimrc() abort
    execute printf('source %s', $MYVIM_VIMRC)
    if has('gui_running')
      execute printf('source %s', $MYVIM_GVIMRC)
    endif
    redraw
    echo printf('.vimrc/.gvimrc has reloaded (%s).', strftime('%c'))
  endfunction
endif
nnoremap <silent> <Plug>(my-reload-vimrc)
      \ :<C-u>call <SID>reload_vimrc()<CR>
nmap <Leader><Leader>r <Plug>(my-reload-vimrc)
" }}}

" source/reload current vimscript file " {{{
function! s:source_current_vimscript() abort
  let abspath = resolve(expand('%:p'))
  if &filetype !=# 'vim'
    redraw
    echohl WarningMsg
    echo printf(
          \ 'The filetype of the current buffer is "%s" but it must be "vim" for source.',
          \ &filetype,
          \)
    echohl None
    return
  elseif abspath ==# $MYVIMRC || abspath ==# $MYGVIMRC
    redraw
    echohl WarningMsg
    echo 'The .vimrc/.gvimrc cannot be reloaded by this function. Use <Plug>(my-reload-vimrc) instead.'
    echohl None
    return
  endif
  execute printf('source %s', expand('%'))
  redraw
  echo printf('"%s" has sourced (%s).', expand('%:t'), strftime('%c'))
endfunction
nmap <silent> <Plug>(my-source) :<C-u>call <SID>source_current_vimscript()<CR>
nmap <LocalLeader><LocalLeader>s <Plug>(my-source)
" }}}

" automatically create missing directories {{{
function! s:makedirs(dir, force) abort
  if a:dir =~# '^.\{-}://'
      " Non local file, ignore
      return
  endif
  if !isdirectory(a:dir)
    if a:force || input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$'
      call mkdir(a:dir, 'p')
    endif
  endif
endfunction
autocmd MyAutoCmd BufWritePre * call s:makedirs(expand('<afile>:p:h'), v:cmdbang)
" }}}

" automatically change working directory on vim enter {{{
function! s:workon(dir, bang) abort
  let dir = (a:dir ==# '' ? expand('%') : a:dir)
  " convert filename to directory if required
  if filereadable(dir)
    let dir = fnamemodify(expand(dir),':p:h')
  else
    let dir = fnamemodify(dir, ':p')
  endif
  " change directory to specified directory
  if isdirectory(dir)
    silent execute 'cd ' . fnameescape(dir)
    if a:bang ==# ''
      redraw | echo 'Working on: '.dir
      if v:version > 703 || (v:version == 703 && has('patch438'))
        doautocmd <nomodeline> MyAutoCmd User my-workon-post
      else
        doautocmd MyAutoCmd User my-workon-post
      endif
    endif
  endif
endfunction
autocmd MyAutoCmd VimEnter * call s:workon(expand('<afile>'), 1)
command! -nargs=? -complete=dir -bang Workon call s:workon('<args>', '<bang>')
" }}}

" toggle quickfix window {{{
function! s:toggle_qf() abort
  let nwin = winnr('$')
  cclose
  if nwin == winnr('$')
    cwindow
  endif
endfunction
nnoremap <silent> <Leader>q :call <SID>toggle_qf()<CR>
" }}}

" Automatically re-assign filetype {{{
autocmd MyAutoCmd BufWritePost *
      \ if &filetype ==# '' || exists('b:ftdetect') |
      \  unlet! b:ftdetect |
      \  filetype detect |
      \ endif
"}}}

" Use relative syntax when the file is too big {{{
autocmd MyAutoCmd Syntax *
      \ if line('%') > 1000 |
      \  syntax sync minlines=100 |
      \ endif
" }}}

" Profiling a command {{{
function! s:timeit(q_args) abort
  let q_args = a:q_args
  let q_args = substitute(q_args, '^[\t :]\+', '', '')
  let q_args = substitute(q_args, '\s\+$', '', '')
  let args = substitute(q_args, '^[ :]*!', '', '')
  let start = reltime()
  try
    if q_args !=# '' && q_args[0] ==# '!'
      echo system(args)
    else
      execute q_args
    endif
  finally
    echomsg printf('Timeit: %s s [%s]', reltimestr(reltime(start)), a:q_args)
  endtry
endfunction
command! -nargs=+ -bang -complete=command Timeit call s:timeit(<q-args>)
" }}}

" Clear messages {{{
function! s:message_clear() abort
  for i in range(201)
    echomsg ''
  endfor
endfunction
command! -nargs=0 MessageClear call s:message_clear()
" }}}

" Better macro {{{
function! s:execute_macro_over_visual_range() abort
  execute ":'<,'>normal @" . nr2char(getchar())
endfunction
xnoremap <silent> <Plug>(my-execute-macro)
      \ :<C-u>call <SID>execute_macro_over_visual_range()<CR>
xmap @ <Plug>(my-execute-macro)
" }}}

" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker
