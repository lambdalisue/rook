call denite#custom#source(
        \ 'file_mru',
        \ 'matchers',
        \ ['matcher_fuzzy', 'matcher_project_files']
        \)
call denite#custom#source(
        \ 'file_rec',
        \ 'matchers',
        \ ['matcher_cpsm']
        \)

" grep
if executable('pt')
  " Use pt (the platinum searcher)
  " https://github.com/monochromegane/the_platinum_searcher
  let g:unite_source_grep_command = 'pt'
  let g:unite_source_grep_default_opts = '--nogroup --nocolor'
  let g:unite_source_grep_recursive_opt = ''
  call denite#custom#var(
        \ 'file_rec',
        \ 'command',
        \ ['pt', '--follow', '--nocolor', '--nogroup']
        \)

  call denite#custom#var('grep', 'command', ['pt'])
  call denite#custom#var('grep', 'recursive_opts', [''])
  call denite#custom#var('grep', 'final_opts', [''])
  call denite#custom#var('grep', 'separator', [''])
  call denite#custom#var(
        \ 'grep', 'default_opts',
        \ ['--nocolor', '--nogroup', '--column']
        \)
endif
