scriptencoding utf-8
let g:loaded_netrwPlugin = 1

function! neobundle#hooks.on_source(bundle)
  let g:vimfiler_as_default_explorer = 1
  let g:vimfiler_ignore_pattern = printf('\%%(%s\)', join([
        \ '^\..*',
        \ '\.pyc$',
        \ '^__pycache__$',
        \ '\.egg-info$',
        \], "\\|"))
  call vimfiler#custom#profile('default', 'context', {
        \ 'auto_cd': 1,
        \ 'parent': 1,
        \ 'safe': 0,
        \ })
endfunction

function! s:configure_vimfiler() abort
  " use 'J' to select candidates instead of <Space> / <S-Space>
  nunmap <buffer> <Space>
  nunmap <buffer> <S-Space>
  vunmap <buffer> <Space>
  nmap <buffer> J <Plug>(vimfiler_toggle_mark_current_line)
  vmap <buffer> J <Plug>(vimfiler_toggle_mark_selected_lines)
  " ^^ to go parent directory
  nmap <buffer> ^^ <Plug>(vimfiler_switch_to_parent_directory)
  " X to execute on the directory
  nmap <buffer> X
        \ <Plug>(vimfiler_switch_to_parent_directory)
        \ <Plug>(vimfiler_execute_system_associated)
        \ <Plug>(vimfiler_execute)
  " <Space>k to open bookmark
  nmap <buffer><silent> <Space>k :<C-u>Unite bookmark<CR>
endfunction
autocmd MyAutoCmd FileType vimfiler call s:configure_vimfiler()

" XXX: This is a work around
" Note:
"   Somehow, &winfixwidth of a buffer opened from VimFilerExplorer is set to
"   1 and thus <C-w>= or those kind of command doesn't work.
"   This work around stands for fixing that.
function! s:force_nofixwidth() abort
  if empty(&l:buftype)
    setl nowinfixwidth
  endif
endfunction
autocmd MyAutoCmd BufWinEnter * call s:force_nofixwidth()

nnoremap <Plug>(my-vimfiler) <Nop>
nmap <Leader>e <Plug>(my-vimfiler)
nnoremap <silent> <Plug>(my-vimfiler)e :<C-u>VimFilerExplorer<CR>
nnoremap <silent> <Plug>(my-vimfiler)E :<C-u>VimFiler<CR>
