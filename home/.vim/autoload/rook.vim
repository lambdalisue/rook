" platform recognition
let s:is_windows = has('win16') || has('win32') || has('win64')
let s:is_darwin  = has('mac') || has('macunix') || has('gui_macvim')
let s:is_linux   = !s:is_windows && !s:is_darwin
let s:delimiter  = s:is_windows ? ';' : ':'
let s:pathsep    = s:is_windows ? '\\' : '/'
let s:sfile      = expand('<sfile>')

function! rook#expand(expr) abort " {{{
  let path = expand(a:expr)
  let path = printf('%s%s%s',
        \ fnamemodify(s:sfile, ':h'),
        \ s:pathsep,
        \ path,
        \)
  return path
endfunction " }}}

function! rook#add_path(pathlist) abort " {{{
  let pathlist = split($PATH, s:delimiter)
  for path in map(filter(a:pathlist, 'v:val'), 'expand(v:val)') 
    if isdirectory(path) && index(pathlist, path) == -1
      call insert(pathlist, path, 0)
    endif
  endfor
  let $PATH = join(pathlist, s:delimiter)
endfunction " }}}

function! rook#source(path) abort " {{{
  let path = expand(a:path)
  if filereadable(path)
    execute printf('source %s', path)
    return 1
  endif
  return 0
endfunction " }}}
