if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

setlocal iskeyword&
setlocal iskeyword+=:
setlocal iskeyword+=#
setlocal iskeyword+=-
setlocal iskeyword+=.
setlocal iskeyword+=(
setlocal iskeyword+=)
setlocal tabstop=8
setlocal softtabstop=8
setlocal shiftwidth=8     " width of Indent
setlocal nosmarttab       " use 'shiftwidth' and 'softtabstop' for indentation
setlocal noexpandtab
setlocal nospell
setlocal nolist
if v:version >= 703
  setlocal conceallevel=2
  " keep conceal of current line in command mode
  setlocal concealcursor=nc
endif

" Each lines should be shorter than 78 characters
setlocal textwidth=78
if exists('&colorcolumn')
  setlocal colorcolumn=78
endif

" Close with q
nnoremap <buffer><expr> q &modifiable ? 'q' : ':<C-u>close<CR>'
