setlocal nofoldenable
setlocal foldcolumn=0
setlocal nonumber
setlocal norelativenumber

if has('nvim')
  " Use <ESC> to escape from terminal mode
  tnoremap <Esc> <C-\><C-n>
  tnoremap g<Esc> <Esc>
endif
