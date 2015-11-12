scriptencoding utf-8
set noshowmode

let g:lightline = {
      \ 'colorscheme': 'hybrid',
      \ 'active': {
      \   'left': [
      \     [ 'mode', 'paste' ],
      \     [ 'filename' ],
      \   ],
      \   'right': [
      \     [ 'qfstatusline' ],
      \     [ 'lineinfo' ],
      \     [ 'fileformat', 'fileencoding', 'filetype' ],
      \   ],
      \ },
      \ 'inactive': {
      \   'left': [
      \     [ 'filename' ],
      \   ],
      \   'right': [
      \     [ 'fileformat', 'fileencoding', 'filetype' ],
      \   ],
      \ },
      \ 'tabline': {
      \   'left': [
      \     [ 'tabs' ],
      \   ],
      \   'right': [
      \     [ 'close' ],
      \     [ 'pyenv', 'gita_debug', 'gita_branch', 'gita_traffic', 'gita_status', 'cwd' ],
      \   ],
      \ },
      \ 'component_visible_condition': {
      \   'lineinfo': '(winwidth(0) >= 70)',
      \ },
      \ 'component_expand': {
      \   'qfstatusline': 'qfstatusline#Update',
      \ },
      \ 'component_type': {
      \   'qfstatusline': 'error',
      \ },
      \ 'component_function': {
      \   'mode': 'lightline#mode',
      \   'cwd': 'g:lightline.my.cwd',
      \   'filename': 'g:lightline.my.filename',
      \   'fileformat': 'g:lightline.my.fileformat',
      \   'fileencoding': 'g:lightline.my.fileencoding',
      \   'filetype': 'g:lightline.my.filetype',
      \   'gita_debug': 'g:lightline.my.gita_debug',
      \   'gita_branch': 'g:lightline.my.gita_branch',
      \   'gita_traffic': 'g:lightline.my.gita_traffic',
      \   'gita_status': 'g:lightline.my.gita_status',
      \   'pyenv': 'g:lightline.my.pyenv',
      \ },
      \}
" Note:
"   component_function cannot be a script local function so use
"   g:lightline.my namespace instead of s:
let g:lightline.my = {}
if $LANG ==# 'C'
  let g:lightline.my.symbol_branch = ''
  let g:lightline.my.symbol_readonly = '!'
  let g:lightline.my.symbol_modified = '*'
  let g:lightline.my.symbol_nomodifiable = '#'
else
  let g:lightline.my.symbol_branch = '⭠'
  let g:lightline.my.symbol_readonly = '⭤'
  let g:lightline.my.symbol_modified = '*'
  let g:lightline.my.symbol_nomodifiable = '#'
endif
function! g:lightline.my.cwd() abort
  return fnamemodify(getcwd(), ':~')
endfunction
function! g:lightline.my.readonly() abort
  return empty(&buftype) && &readonly ? g:lightline.my.symbol_readonly : ''
endfunction
function! g:lightline.my.modified() abort
  return empty(&buftype) && &modified ? g:lightline.my.symbol_modified : ''
endfunction
function! g:lightline.my.nomodifiable() abort
  return empty(&buftype) && !&modifiable ? g:lightline.my.symbol_nomodifiable : ''
endfunction
function! g:lightline.my.filename() abort
  if empty(&buftype)
    let fname = winwidth(0) > 79 ? expand('%') : pathshorten(expand('%'))
    let readonly = g:lightline.my.readonly()
    let modified = g:lightline.my.modified()
    let nomodifiable = g:lightline.my.nomodifiable()
    return '' .
          \ (empty(readonly) ? '' : readonly . ' ') .
          \ (empty(fname) ? '[No name]' : fname) .
          \ (empty(nomodifiable) ? '' : ' ' . nomodifiable) .
          \ (empty(modified) ? '' : ' ' . modified)
  else
    let ft = &filetype
    if ft =~# '\v%(unite|vimfiler|vimshell)'
      return {ft}#get_status_string()
    endif
  endif
  return ''
endfunction
function! g:lightline.my.fileformat() abort
    return winwidth(0) > 70 ? &fileformat : ''
endfunction
function! g:lightline.my.filetype() abort " {{{
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction " }}}
function! g:lightline.my.fileencoding() abort "{{{
  return winwidth(0) > 70 ? (strlen(&fileencoding) ? &fileencoding : &encoding) : ''
endfunction " }}}

if neobundle#is_installed('vim-gita')
  function! g:lightline.my.gita_debug() abort
    return neobundle#is_sourced('vim-gita')
          \ ? gita#statusline#debug() : ''
  endfunction
  function! g:lightline.my.gita_branch() abort
    return neobundle#is_sourced('vim-gita')
          \ ? gita#statusline#preset('branch_short_fancy') : ''
  endfunction
  function! g:lightline.my.gita_traffic() abort
    return neobundle#is_sourced('vim-gita')
          \ ? gita#statusline#preset('traffic_fancy') : ''
  endfunction
  function! g:lightline.my.gita_status() abort
    return neobundle#is_sourced('vim-gita')
          \ ? gita#statusline#preset('status') : ''
  endfunction
else
  function! g:lightline.my.gita_debug() abort
    return ''
  endfunction
  function! g:lightline.my.gita_branch() abort
    return ''
  endfunction
  function! g:lightline.my.gita_traffic() abort
    return ''
  endfunction
  function! g:lightline.my.gita_status() abort
    return ''
  endfunction
endif

if neobundle#is_installed('vim-pyenv')
  function! g:lightline.my.pyenv() abort
    if neobundle#is_sourced('vim-pyenv')
      return pyenv#info#preset('long')
    else
      return ''
    endif
  endfunction
else
  function! g:lightline.my.pyenv() abort
    return ''
  endfunction
endif
