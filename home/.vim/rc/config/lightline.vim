scriptencoding utf-8

function! s:is_filelike() abort
  return &buftype =~# '^\|nowrite\|acwrite$'
endfunction

let g:lightline = {
      \ 'colorscheme': 'jellybeans',
      \ 'active': {
      \   'left': [
      \     [ 'mode', 'paste' ],
      \     [ 'filename' ],
      \   ],
      \   'right': [
      \     [ 'qfstatusline' ],
      \     [ 'lineinfo' ],
      \     [ 'fileformat', 'fileencoding', 'filetype' ],
      \     [ 'highlight' ],
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
      \     [ 'pyenv', 'gita_branch', 'gita_traffic', 'gita_status', 'cwd' ],
      \   ],
      \ },
      \ 'component_visible_condition': {
      \   'lineinfo': '(winwidth(0) >= 70)',
      \ },
      \ 'component_expand': {
      \   'qfstatusline': 'g:lightline.my.qfstatusline',
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
      \   'git_branch': 'g:lightline.my.git_branch',
      \   'gita_branch': 'g:lightline.my.gita_branch',
      \   'gita_traffic': 'g:lightline.my.gita_traffic',
      \   'gita_status': 'g:lightline.my.gita_status',
      \   'pyenv': 'g:lightline.my.pyenv',
      \   'highlight': 'g:lightline.my.highlight',
      \ },
      \}

" Note:
"   component_function cannot be a script local function so use
"   g:lightline.my namespace instead of s:
let g:lightline.my = {}

if !has('multi_byte') || $LANG ==# 'C'
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
  return s:is_filelike() && &readonly ? g:lightline.my.symbol_readonly : ''
endfunction

function! g:lightline.my.modified() abort
  return s:is_filelike() && &modified ? g:lightline.my.symbol_modified : ''
endfunction

function! g:lightline.my.nomodifiable() abort
  return s:is_filelike() && !&modifiable ? g:lightline.my.symbol_nomodifiable : ''
endfunction

function! g:lightline.my.filename() abort
  if &filetype =~# '\v%(unite|vimfiler|vimshell)'
    return {&filetype}#get_status_string()
  elseif &filetype =~# '\v%(gita-blame-navi)'
    let fname = winwidth(0) > 79 ? expand('%') : get(split(expand('%'), ':'), 2, 'NAVI')
    return fname
  elseif &filetype ==# 'gista-list'
    return gista#command#list#get_status_string()
  else
    let fname = winwidth(0) > 79 ? expand('%') : pathshorten(expand('%'))
    let readonly = g:lightline.my.readonly()
    let modified = g:lightline.my.modified()
    let nomodifiable = g:lightline.my.nomodifiable()
    return '' .
          \ (empty(readonly) ? '' : readonly . ' ') .
          \ (empty(fname) ? '[No name]' : fname) .
          \ (empty(nomodifiable) ? '' : ' ' . nomodifiable) .
          \ (empty(modified) ? '' : ' ' . modified)
  endif
  return ''
endfunction

function! g:lightline.my.fileformat() abort
    return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! g:lightline.my.filetype() abort
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! g:lightline.my.fileencoding() abort
  return winwidth(0) > 70 ? (strlen(&fileencoding) ? &fileencoding : &encoding) : ''
endfunction

function! g:lightline.my.gita_branch() abort
  return dein#is_sourced('vim-gita')
        \ ? gita#statusline#preset('branch_short_fancy') : ''
endfunction

function! g:lightline.my.gita_traffic() abort
  return dein#is_sourced('vim-gita')
        \ ? gita#statusline#preset('traffic_fancy') : ''
endfunction

function! g:lightline.my.gita_status() abort
  return dein#is_sourced('vim-gita')
        \ ? gita#statusline#preset('status') : ''
endfunction

function! g:lightline.my.pyenv() abort
  return dein#is_sourced('vim-pyenv')
        \ ? pyenv#info#preset('long') : ''
endfunction

function! g:lightline.my.highlight() abort
  let [nline, ncol] = getpos('.')[1:2]
  return synIDattr(synID(nline, ncol, 1), 'name')
endfunction

function! g:lightline.my.qfstatusline() abort
  if dein#is_sourced('vim-qfstatusline')
    let message = qfstatusline#Update()
    let message = substitute(
          \ message,
          \ '(@INC contains: .*)',
          \ '', ''
          \)
    return winwidth(0) > 79 ? message[ : winwidth(0) ] : ''
  else
    return ''
  endif
endfunction
