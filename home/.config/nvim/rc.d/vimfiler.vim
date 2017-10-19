let g:vimfiler_as_default_explorer = 1
let g:vimfiler_ignore_pattern = printf('\%%(%s\)', join([
      \ '^\..*',
      \ '\.pyc$',
      \ '^__pycache__$',
      \ '\.egg-info$',
      \], '\|'))

call vimfiler#custom#profile('default', 'context', {
      \ 'parent': 1,
      \ 'safe': 0,
      \ })

function! s:configure_vimfiler() abort
  " use 'J' to select candidates instead of <Space> / <S-Space>
  silent! nunmap <buffer> <Space>
  silent! nunmap <buffer> <S-Space>
  silent! vunmap <buffer> <Space>
  nmap <buffer> J <Plug>(vimfiler_toggle_mark_current_line)
  vmap <buffer> J <Plug>(vimfiler_toggle_mark_selected_lines)
  " ^^ to go parent directory
  nmap <buffer> ^^ <Plug>(vimfiler_switch_to_parent_directory)
  " X to execute on the directory
  nmap <buffer> X
        \ <Plug>(vimfiler_switch_to_parent_directory)
        \ <Plug>(vimfiler_execute_system_associated)
        \ <Plug>(vimfiler_execute)
  " t to open tab
  nnoremap <buffer><silent> <Plug>(vimfiler_tab_edit_file)
        \ :<C-u>call vimfiler#mappings#do_action(b:vimfiler, 'tabopen')<CR>
  nmap <buffer> t <Plug>(vimfiler_tab_edit_file)
endfunction

function! s:enable_cd_to_cwd_on_edit() abort
  setlocal buftype=nowrite
  augroup _vimfiler_cd_to_cwd_on_edit
    autocmd! *
    autocmd BufReadCmd <buffer> call vimfiler#mappings#cd(getcwd())
  augroup END
endfunction

" XXX: This is a work around
" Note:
"   Somehow, &winfixwidth of a buffer opened from VimFilerExplorer is set to
"   1 and thus <C-w>= or those kind of command doesn't work.
"   This work around stands for fixing that.
function! s:force_nofixwidth() abort
  let last_bufnr = winbufnr(winnr('#'))
  if bufname(last_bufnr) =~# '^vimfiler:'
    setlocal nowinfixwidth
  endif
endfunction

augroup my_vimfiler_configure
  autocmd! *
  autocmd BufWinEnter * call s:force_nofixwidth()
  autocmd FileType vimfiler call s:configure_vimfiler()
  autocmd FileType vimfiler call s:enable_cd_to_cwd_on_edit()
augroup END
" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker
