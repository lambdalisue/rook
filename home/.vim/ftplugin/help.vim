setl iskeyword&
setl iskeyword+=:
setl iskeyword+=#
setl iskeyword+=-
setl iskeyword+=.
setl iskeyword+=(
setl iskeyword+=)
setl tabstop=8
setl softtabstop=8
setl shiftwidth=8     " width of Indent
setl nosmarttab       " use 'shiftwidth' and 'softtabstop' for indentation
setl noexpandtab
setl nospell
if v:version >= 703
  setl conceallevel=2
  " keep conceal of current line in command mode
  setl concealcursor=nc
endif

" Each lines should be shorter than 78 characters
setl textwidth=78
if exists('&colorcolumn')
  setl colorcolumn=
endif
