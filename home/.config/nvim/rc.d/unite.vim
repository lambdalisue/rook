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
