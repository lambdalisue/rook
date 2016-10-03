if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

" https://github.com/vim-perl/vim-perl/issues/170
"let g:perl_fold = 0
let g:perl_fold_blocks = 1
let g:perl_fold_anonymous_subs = 1
let g:perl_nofold_packages = 1

setl tabstop=8        " width of TAB should be 8 characters
setl softtabstop=4    " 4 continuous spaces are assumed as Soft tab
setl shiftwidth=4     " width of Indent
setl smarttab         " use 'shiftwidth' and 'softtabstop' for indentation
setl expandtab        " use continuous spaces as TAB

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
