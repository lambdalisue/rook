function! s:dein_command(args) abort
  let args = split(a:args)
  let name, args = args[0], args[1:]
  call call('dein#' . name, args)
endfunction

function! s:dein_complete(arglead, cmdline, cursorpos) abort
  let args = split(a:args)
  let name, args = args[0], args[1:]
  if index(['install', 'reinstall', 'update', 'source'], name) == -1
    return []
  endif
  return join(filter(keys(dein#get()), 'index(args, v:val) == -1'), "\n")
endfunction

command! -nargs=* -complete=custom,s:dein_complete Dein call s:dein_command(<q-bang>)
