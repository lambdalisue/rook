function! s:off_at_non_eol(char) abort
  call lexima#add_rule({
        \ 'char': a:char,
        \ 'at': '\%#\S\+$',
        \ 'input': a:char,
        \})
endfunction
for char in split('([{<"''', '\zs')
  call s:off_at_non_eol(char)
endfor
