scriptencoding utf-8

function! s:is_filelike() abort
  return &buftype =~# '^\|nowrite\|acwrite$'
endfunction

let s:Symbols = {
      \ 'branch': '',
      \ 'readonly': '☼',
      \ 'modified': '∙',
      \ 'nomodifiable': '¬',
      \ 'error': '',
      \ 'python': 'ρ ',
      \ 'unix': '',
      \ 'dos': '¶',
      \ 'separator_left': '▒',
      \ 'separator_right': '▒',
      \}

let g:lightline = {
      \ 'colorscheme': 'tender',
      \ 'active': {
      \   'left': [
      \     [ 'mode', 'paste' ],
      \     [ 'filename' ],
      \   ],
      \   'right': [
      \     [ 'qfstatusline' ],
      \     [ 'fileinfo' ],
      \     [ 'filetype' ],
      \   ],
      \ },
      \ 'inactive': {
      \   'left': [
      \     [ 'filename' ],
      \   ],
      \   'right': [
      \     [ 'fileinfo' ],
      \     [ 'filetype' ],
      \   ],
      \ },
      \ 'tabline': {
      \   'left': [
      \     [ 'cwd' ],
      \     [ 'tabs' ],
      \   ],
      \   'right': [
      \     [
      \       'wifi',
      \       'battery',
      \       'datetime',
      \     ],
      \     [
      \       'pyenv',
      \       'gita_branch',
      \       'gita_traffic',
      \       'gita_status',
      \     ],
      \   ],
      \ },
      \ 'component_expand': {
      \   'qfstatusline': 'g:lightline.my.qfstatusline',
      \ },
      \ 'component_type': {
      \   'qfstatusline': 'error',
      \ },
      \ 'component_function': {
      \   'mode': 'lightline#mode',
      \   'wifi': 'wifi#component',
      \   'battery': 'battery#component',
      \   'cwd': 'g:lightline.my.cwd',
      \   'filename': 'g:lightline.my.filename',
      \   'fileinfo': 'g:lightline.my.fileinfo',
      \   'filetype': 'g:lightline.my.filetype',
      \   'datetime': 'g:lightline.my.datetime',
      \   'git_branch': 'g:lightline.my.git_branch',
      \   'gita_branch': 'g:lightline.my.gita_branch',
      \   'gita_traffic': 'g:lightline.my.gita_traffic',
      \   'gita_status': 'g:lightline.my.gita_status',
      \   'pyenv': 'g:lightline.my.pyenv',
      \ },
      \ 'separator': {
      \   'left': s:Symbols.separator_left,
      \   'right': s:Symbols.separator_right,
      \ },
      \ 'tabline_separator': {
      \   'left': s:Symbols.separator_left,
      \   'right': s:Symbols.separator_right,
      \ },
      \}

" Note:
"   component_function cannot be a script local function so use
"   g:lightline.my namespace instead of s:
let g:lightline.my = {}

function! g:lightline.my.cwd() abort
  return fnamemodify(getcwd(), ':~')
endfunction

function! g:lightline.my.readonly() abort
  return s:is_filelike() && &readonly
        \ ? s:Symbols.readonly
        \ : ''
endfunction

function! g:lightline.my.modified() abort
  return s:is_filelike() && &modified
        \ ? s:Symbols.modified
        \ : ''
endfunction

function! g:lightline.my.nomodifiable() abort
  return s:is_filelike() && !&modifiable
        \ ? s:Symbols.nomodifiable
        \ : ''
endfunction

function! g:lightline.my.filename() abort
  if &filetype =~# '\v%(unite|vimfiler|vimshell)'
    return {&filetype}#get_status_string()
  elseif &filetype =~# '\v%(gita-blame-navi)'
    let fname = winwidth(0) > 79
          \ ? expand('%:~:.')
          \ : get(split(expand('%:~:.'), ':'), 2, 'NAVI')
    return fname
  elseif &filetype ==# 'gista-list'
    return gista#command#list#get_status_string()
  else
    let fname = winwidth(0) > 79
          \ ? expand('%:~:.')
          \ : pathshorten(expand('%:~:.'))
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

function! g:lightline.my.fileinfo() abort
  let encoding = (strlen(&fileencoding) ? &fileencoding : &encoding)
  let fileformat = &fileformat ==# 'unix'
        \ ? s:Symbols.unix
        \ : s:Symbols.dos
  return encoding . ' ' . fileformat
endfunction

function! g:lightline.my.filetype() abort
  return &filetype
endfunction

function! g:lightline.my.gita_branch() abort
  if !dein#is_sourced('vim-gita')
    return ''
  endif
  let branch = gita#statusline#preset('branch_short')
  return empty(branch) ? '' : s:Symbols.branch . branch
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
  if !dein#is_sourced('vim-pyenv')
    return ''
  endif
  return pyenv#info#format(s:Symbols.python . '%av(%iv/%ev)')
endfunction

function! g:lightline.my.qfstatusline() abort
  if dein#is_sourced('vim-qfstatusline')
    let message = qfstatusline#Update()
    let message = substitute(
          \ message,
          \ '(@INC contains: .*)',
          \ '', ''
          \)
    let prefix = len(message) ? s:Symbols.error : ''
    return winwidth(0) > 79
          \ ? prefix . message[ : winwidth(0) ]
          \ : prefix
  else
    return ''
  endif
endfunction

function! g:lightline.my.datetime() abort
  return strftime('%a %m/%d %H:%M')
endfunction

if !has('vim_starting')
  call lightline#init()
endif
