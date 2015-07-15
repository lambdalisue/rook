let s:save_cpo = &cpo
set cpo&vim

" to continue lines in applescript, ￢ is required to be the end of line.
" what da hell.
inoremap <silent><buffer> <Plug>(applescript-continue-line)  ￢<CR>
imap <buffer> <S-CR> <Plug>(applescript-continue-line)

let g:quickrun_config = get(g:, 'quickrun_config', {})
let g:quickrun_config.applescript = {
      \ 'command': 'osascript',
      \ 'output': '_',
      \}

let &cpo = s:save_cpo
" vim:set et ts=2 sts=2 sw=2 tw=0 fdm=marker:
