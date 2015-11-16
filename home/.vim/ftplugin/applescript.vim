scriptencoding utf-8

if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

" To continue lines in applescript, ￢ is required to be the end of line.
inoremap <silent><buffer> <Plug>(applescript-continue-line)  ￢<CR>
imap <buffer> <S-CR> <Plug>(applescript-continue-line)

let g:quickrun_config = get(g:, 'quickrun_config', {})
let g:quickrun_config.applescript = {
      \ 'command': 'osascript',
      \ 'output': '_',
      \}
