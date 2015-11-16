if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

setl iskeyword&
setl iskeyword+=:

" check if the package name and file name are mismached {{{ 
function! s:get_package_name()
    let mx = '^\s*package\s\+\([^ ;]\+\)'
    for line in getline(1, 5)
        if line =~ mx
        return substitute(matchstr(line, mx), mx, '\1', '')
        endif
    endfor
    return ''
endfunction
function! s:check_package_name()
    let path = substitute(expand('%:p'), '\\', '/', 'g')
    let name = substitute(s:get_package_name(), '::', '/', 'g') . '.pm'
    if path[-len(name):] != name
      redraw
      echohl WarningMsg
      echo printf(
            \ 'It seems that the package name (%s) ' .
            \ 'and file path (%s) are mismatched.',
            \ name, path[-len(name):],
            \)
      echo 'It is strongly recommended to rename the package name or file'
      echohl None
    endif
endfunction
autocmd! MyAutoCmd BufWritePost *.pm call s:check_package_name()

if executable('perltidy')
  nnoremap <buffer> <Plug>(my-perltidy) <Nop>
  nnoremap <buffer><silent> <Plug>(my-perltidy) :<C-u>%! perltidy -se<CR>
  vnoremap <buffer><silent> <Plug>(my-perltidy) :<C-u>'<,'>! perltidy -se<CR>
  nmap <buffer> <LocalLeader>pt <Plug>(my-perltidy)
  vmap <buffer> <LocalLeader>pt <Plug>(my-perltidy)
endif
