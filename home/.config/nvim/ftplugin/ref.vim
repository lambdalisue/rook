if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

setlocal nolist
setlocal nospell

" Close with q
nnoremap <buffer><expr> q &modifiable ? 'q' : ':<C-u>close<CR>'

