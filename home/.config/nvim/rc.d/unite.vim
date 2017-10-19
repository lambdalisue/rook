call unite#custom#profile('default', 'context', {
      \ 'start_insert': 1,
      \ 'no_empty': 1,
      \})
call unite#custom#default_action('directory', 'cd')
call unite#custom#alias('file', 'edit', 'open')

" grep
if executable('pt')
  " Use pt (the platinum searcher)
  " https://github.com/monochromegane/the_platinum_searcher
  let g:unite_source_grep_command = 'pt'
  let g:unite_source_grep_default_opts = '--nogroup --nocolor'
  let g:unite_source_grep_recursive_opt = ''
endif

" Alias
let g:unite_source_alias_aliases = {
      \ 'map': {
      \   'source': 'output',
      \   'args': 'map|map!|lmap',
      \ },
      \}

function! s:unite_my_settings() abort
  silent! iunmap <buffer> <C-p>
  silent! iunmap <buffer> <C-n>
  silent! nunmap <buffer> <C-p>
  silent! nunmap <buffer> <C-n>
  imap <buffer> <C-t> <Plug>(unite_select_previous_line)
  imap <buffer> <C-g> <Plug>(unite_select_next_line)
  nmap <buffer> <C-t> <Plug>(unite_loop_cursor_up)
  nmap <buffer> <C-g> <Plug>(unite_loop_cursor_down)
  imap <buffer> <C-j> <Plug>(unite_do_default_action)
  nmap <buffer> <C-j> <Plug>(unite_do_default_action)
endfunction
autocmd MyAutoCmd FileType unite call s:unite_my_settings()
