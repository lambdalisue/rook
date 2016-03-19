let s:available_commands = [
      \ 'direct_install',
      \ 'install',
      \ 'update',
      \ 'reinstall',
      \ 'remote_plugins',
      \ 'check_lazy_plugins',
      \ 'check_clean',
      \ 'recache_runtimepath',
      \ 'source',
      \ 'clear_state',
      \]

function! s:dein_command(args) abort
  let args = split(a:args)
  if len(args) == 0
    echo 'Usage: Dein {command} [{args}...]'
    return
  endif
  let name = args[0]
  let args = len(args) > 1 ? args[1:] : []
  call call('dein#' . name, args)
endfunction

function! s:dein_complete(arglead, cmdline, cursorpos) abort
  let args = split(a:cmdline)[1:]
  if len(args) == !empty(a:arglead)
    return join(s:available_commands, "\n")
  endif
  let name = args[0]
  let args = len(args) > 1 ? args[1:] : []
  if index(['install', 'reinstall', 'update', 'source'], name) == -1
    return ''
  endif
  return join(filter(keys(dein#get()), 'index(args, v:val) == -1'), "\n")
endfunction

command! -nargs=* -complete=custom,s:dein_complete Dein call s:dein_command(<q-args>)
