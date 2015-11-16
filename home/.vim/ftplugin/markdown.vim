if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

setl spell
setl autoindent
setl textwidth=0
setl colorcolumn=80
setl expandtab
setl softtabstop=4
setl shiftwidth=4
setl formatoptions+=tqn
setl formatlistpat=^\\s*\\(\\d\\+\\\|[a-z]\\)[\\].)]\\s*
