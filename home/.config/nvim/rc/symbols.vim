" NOTE:
" Most of the following symobls are defined in "Nerd Fonts"
" Install from https://github.com/ryanoasis/nerd-fonts#font-installation
scriptencoding utf-8


function! s:define_ascii_symbols() abort
  let symbols = {
        \ 'branch': '',
        \ 'readonly': '!',
        \ 'modified': '*',
        \ 'nomodifiable': '#',
        \ 'error': '!!! ',
        \ 'python': '# ',
        \ 'separator_left': '',
        \ 'separator_right': '',
        \}
  return symbols
endfunction

function! s:define_unicode_symbols() abort
  let symbols = {
        \ 'branch': '⭠',
        \ 'readonly': '⭤',
        \ 'modified': ' ',
        \ 'nomodifiable': ' ',
        \ 'error': ' ',
        \ 'python': ' ',
        \ 'separator_left': '',
        \ 'separator_right': '',
        \}
  return symbols
endfunction

if !has('multi_byte') || $LANG ==# ’C'
  let Symbols = s:define_ascii_symobls()
else
  let Symbols = s:define_unicode_symbols()
endif
