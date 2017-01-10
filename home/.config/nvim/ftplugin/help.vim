" if exists('b:did_ftplugin')
"   finish
" endif
let b:did_ftplugin = 1
let b:undo_ftplugin = join([
      \ 'setlocal iskeyword<',
      \ 'setlocal tabstop< softtabstop< shiftwidth<',
      \ 'setlocal nosmarttab< noexpandtab<',
      \ 'setlocal nospell<',
      \ 'setlocal nolist<',
      \ 'setlocal conceallevel< concealcursor<',
      \ 'setlocal textwidth< colorcolumn<',
      \ 'silent! nunmap <buffer> q',
      \], ' | ')

setlocal iskeyword&
setlocal iskeyword+=:
setlocal iskeyword+=#
setlocal iskeyword+=-
setlocal iskeyword+=.
setlocal iskeyword+=(
setlocal iskeyword+=)
setlocal tabstop=8 softtabstop=8 shiftwidth=8
setlocal nosmarttab noexpandtab
setlocal nospell
setlocal nolist

setlocal conceallevel=2
setlocal concealcursor=nc

" Each lines should be shorter than 78 characters
setlocal textwidth=78
setlocal colorcolumn=78

" Close with q
nnoremap <buffer><expr> q &modifiable ? 'q' : ':<C-u>close<CR>'
