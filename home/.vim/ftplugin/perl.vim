if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

setl iskeyword& iskeyword+=:

" check if the package name and file name are mismached {{{ 
function! s:get_package_name()
    let mx = '^\s*package\s\+\([^ ;]\+\)'
    for line in getline(1, 5)
        if line =~ mx
        return substitute(matchstr(line, mx), mx, '\1', '')
        endif
    endfor
    return ""
endfunction
function! s:check_package_name()
    let path = substitute(expand('%:p'), '\\', '/', 'g')
    let name = substitute(s:get_package_name(), '::', '/', 'g') . '.pm'
    if path[-len(name):] != name
        echohl WarningMsg
        echomsg "It seems that the package name ("
              \ name
              \ ") and file path ("
              \ path[-len(name):]
              \ "are mismached."
        echomsg "It is strongly recommended to rename the package name or file"
        echohl None
    endif
endfunction
autocmd! MyAutoCmd BufWritePost *.pm call s:check_package_name()

if executable("perltidy")
  nnoremap <buffer> [perltidy] <Nop>
  nmap <buffer> <LocalLeader>pt [perltidy]t
  vmap <buffer> <LocalLeader>pt [perltidy]t

  nmap <buffer><silent> [perltidy]t :<C-u>%! perltidy -se<CR>
  vmap <buffer><silent> [perltidy]t :<C-u>'<,'>! perltidy -se<CR>
endif
