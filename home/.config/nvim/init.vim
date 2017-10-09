"-----------------------------------------------------------------------------
let s:is_windows = has('win32') || has('win64')
let s:separator = s:is_windows ? '\' : '/'
let s:path_separator = s:is_windows ? ';' : ':'
let s:config_root = s:is_windows
      \ ? expand('~/AppData/Local/nvim')
      \ : expand('~/.config/nvim/')
let s:plugin_enabled = 1
let $MYVIM_HOME = s:config_root

" Prelude {{{
if has('vim_starting')
  " Sets the character encoding inside Vim.
  set encoding=utf-8
  scriptencoding utf-8

  " Use defaults.vim and revert several settings
  if filereadable(expand('$VIMRUNTIME/defaults.vim'))
    source $VIMRUNTIME/defaults.vim
  endif
  set history=10000     " increate n of command line history
  set noruler           " [slow] do not show the cursor position.

  " Do not highlight string inside C comments.
  silent! unlet c_comment_strings

  " Use as many color as possible
  if !has('gui_running') && exists('&termguicolors')
    set termguicolors       " use truecolor in term
  endif
  if &term =~# '256color'
    " disable Background Color Erase (BCE) so that color schemes
    " render properly when inside 256-color tmux and GNU screen.
    " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
    set t_ut=
  endif

  " Disable annoying bells
  set noerrorbells
  set novisualbell t_vb=
  if exists('&belloff')
    set belloff=all
  endif

  " Do not wait more than 100 ms for keys
  set timeout
  set ttimeout
  set ttimeoutlen=100

  " Use bash on Vim
  if !has('nvim') && !s:is_windows
    set shell=/bin/bash
  endif

  " Disable unnecessary default plugins
  let g:loaded_gzip              = 1
  let g:loaded_tar               = 1
  let g:loaded_tarPlugin         = 1
  let g:loaded_zip               = 1
  let g:loaded_zipPlugin         = 1
  let g:loaded_rrhelper          = 1
  "let g:loaded_2html_plugin      = 1
  let g:loaded_vimball           = 1
  let g:loaded_vimballPlugin     = 1
  let g:loaded_getscript         = 1
  let g:loaded_getscriptPlugin   = 1
  let g:loaded_logipat           = 1
  let g:loaded_matchparen        = 1
  let g:loaded_man               = 1
  " NOTE:
  " The Netrw is use to download a missing spellfile
  let g:loaded_netrw             = 1
  let g:loaded_netrwPlugin       = 1
  let g:loaded_netrwSettings     = 1
  let g:loaded_netrwFileHandlers = 1
endif
" }}}

" Utility {{{
function! s:join(...) abort
  let items = map(copy(a:000), 'matchstr(v:val, ''.\{-}[\\/]\?$'')')
  return join(items, s:separator)
endfunction

function! s:configure_path(name, pathlist) abort
  let pathlist = split(eval(a:name), s:path_separator)
  for path in map(filter(a:pathlist, '!empty(v:val)'), 'expand(v:val)')
    if isdirectory(path) && index(pathlist, path) == -1
      call insert(pathlist, path, 0)
    endif
  endfor
  execute printf('let %s = join(pathlist, ''%s'')', a:name, s:path_separator)
endfunction

function! s:pick_file(pathspecs) abort
  for pathspec in filter(a:pathspecs, '!empty(v:val)')
    for path in reverse(glob(pathspec, 0, 1))
      if filereadable(path)
        return path
      endif
    endfor
  endfor
  return ''
endfunction

function! s:pick_directory(pathspecs) abort
  for pathspec in filter(a:pathspecs, '!empty(v:val)')
    for path in reverse(glob(pathspec, 0, 1))
      if isdirectory(path)
        return path
      endif
    endfor
  endfor
  return ''
endfunction

function! s:pick_executable(pathspecs) abort
  for pathspec in filter(a:pathspecs, '!empty(v:val)')
    for path in reverse(glob(pathspec, 0, 1))
      if executable(path)
        return path
      endif
    endfor
  endfor
  return ''
endfunction
" }}}

" Environment {{{
call s:configure_path('$PATH', [
      \ '/usr/local/bin',
      \ '/usr/local/texlive/2017basic/bin/x86_64-darwin',
      \ '/usr/local/texlive/2013/bin/x86_64-linux',
      \ '/usr/local/texlive/2013/bin/x86_64-darwin',
      \ '~/.zplug/bin',
      \ '~/.pyenv/bin',
      \ '~/.plenv/bin',
      \ '~/.rbenv/bin',
      \ '~/.ndenv/bin',
      \ '~/.pyenv/shims',
      \ '~/.plenv/shims',
      \ '~/.rbenv/shims',
      \ '~/.ndenv/shims',
      \ '~/.anyenv/envs/pyenv/bin',
      \ '~/.anyenv/envs/plenv/bin',
      \ '~/.anyenv/envs/rbenv/bin',
      \ '~/.anyenv/envs/ndenv/bin',
      \ '~/.anyenv/envs/pyenv/shims',
      \ '~/.anyenv/envs/plenv/shims',
      \ '~/.anyenv/envs/rbenv/shims',
      \ '~/.anyenv/envs/ndenv/shims',
      \ '~/.cabal/bin',
      \ '~/.cache/dein/repos/github.com/thinca/vim-themis/bin',
      \])
call s:configure_path('$MANPATH', [
      \ '/usr/local/share/man/',
      \ '/usr/share/man/',
      \ '/Applications/Xcode.app/Contents/Developer/usr/share/man',
      \ '/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/share/man',
      \])

let $PYENV_ROOT = s:pick_directory([
      \ '~/.anyenv/envs/pyenv',
      \ '~/.pyenv',
      \])

if has('nvim') && !s:is_windows
  let g:python_host_prog = s:pick_executable([
        \ '/usr/local/bin/python2',
        \ '/usr/bin/python2',
        \ '/bin/python2',
        \])
  let g:python3_host_prog = s:pick_executable([
        \ '/usr/local/bin/python3',
        \ '/usr/bin/python3',
        \ '/bin/python3',
        \])
  " NOTE:
  " In my old MacBook Pro, 'python' die unexpectedly somehow.
  " It seems loading libpython2.7 has failed but don't know why.
  " The following line solve this issue (but it would have side-effects)
  " Ref: https://github.com/neovim/neovim/issues/5971
  "      http://d.hatena.ne.jp/eagletmt/20080726/1217085814
  if has('mac')
    let $DYLD_FORCE_FLAT_NAMESPACE=1
  endif
else
  let g:python_host_prog = s:pick_executable([
        \ 'C:\Python27\python.exe',
        \ 'C:\Python26\python.exe',
        \])
  let g:python3_host_prog = s:pick_executable([
        \ 'C:\Python37\python.exe',
        \ 'C:\Python36\python.exe',
        \ '~\AppData\Local\Programs\Python\Python37\python.exe',
        \ 'C:\Program Files\Python37\python.exe',
        \ '~\AppData\Local\Programs\Python\Python36\python.exe',
        \ 'C:\Program Files\Python36\python.exe',
        \])
endif

if executable('lemonade')
  let g:clipboard = {
        \ 'copy': {
        \   '+': 'lemonade copy',
        \   '*': 'lemonade copy',
        \ },
        \ 'paste': {
        \   '+': 'lemonade paste',
        \   '*': 'lemonade paste',
        \ },
        \}
endif

set viewdir=~/.cache/nvim/view
set undodir=~/.cache/nvim/undo
"set spellfile=~/Dropbox/Vim/system/spellfile.utf-8.add
" }}}

" Language {{{

" prefer English interface
"language message C

" prefer English help
set helplang=en,ja

" set default language for spell check
" cjk - ignore spell check on Asian characters (China, Japan, Korea)
set nospell
set spelllang=en_us,cjk
set fileencodings=ucs-bom,utf-8,euc-jp,iso-2022-jp,cp932,utf-16,utf-16le,cp1250
if s:is_windows
  set fileformats=dos,unix,mac
else
  set fileformats=unix,dos,mac
endif
" }}}

" Interface {{{
set emoji               " use double in unicode emoji
set hidden              " hide the buffer instead of close
set switchbuf=useopen   " use an existing buffer instaed of creating a new one

if exists('&signcolumn')
  set signcolumn=yes      " show signcolumn always
endif
set showmatch           " highlight a partner of cursor character
set matchtime=1         " highlight a partner ASAP
set nostartofline       " let C-D, C-U,... to keep same column
set smartcase           " override the ignorecase if the search pattern contains
                        " upper case characters
set tagcase=match       " use case sensitive for tag
set hlsearch            " highlight found terms

set foldlevelstart=99
set foldnestmax=3       " maximum fold nesting level
set foldcolumn=0        " hide fold guide


set laststatus=2        " always shows statusline
set showtabline=2       " always shows tabline
set report=0            " reports any changes
set cmdheight=2
set lazyredraw          " do not redraw while command execution

set splitright          " vsplit to right
set previewheight=20

set sessionoptions-=folds
set sessionoptions-=curdir
set sessionoptions-=options

" https://ddrscott.github.io/blog/2016/sidescroll/
set sidescroll=1

" vertically split buffers for vimdiff
set diffopt& diffopt+=vertical

" move cursor previous/next line when the cursor is first/last character in the
" line and user move the cursor left/right
set whichwrap=b,s,<,>,~,[,]

" store cursor, folds, slash, and unix on view
set viewoptions=cursor

" use rich completion system in command line
set wildmode=list:longest,full
set wildoptions=tagfile

set list          " show invisible characters
if $LANG !=# 'C' && !s:is_windows
  set listchars=tab:»-,trail:_,extends:»,precedes:«,nbsp:%,eol:↵
  set fillchars& fillchars+=vert:│
  set showbreak=
else
  set listchars=tab:>-,trail:-,extends:>,precedes:<,nbsp:%,eol:$
  set fillchars& fillchars+=vert:\|
  set showbreak=
endif
if exists('&breakindent')
  set breakindent   " every wrapped line will continue visually indented
endif

function! FoldText() abort
  let lnum = nextnonblank(v:foldstart)
  let line = lnum > v:foldend
        \ ? getline(v:foldstart)
        \ : substitute(getline(lnum), '\t', repeat(' ', &tabstop), 'g')
  let w = winwidth(0) - &foldcolumn - 3
  let w -= &signcolumn ==# 'no' ? 0 : 2
  let w -= (&number || &relativenumber) ? len(string(line('$'))) + 1 : 0
  let s = (1 + v:foldend - v:foldstart) . ' lines'
  let f = repeat('|', v:foldlevel)
  let e = repeat('.', w - strwidth(line . s . f))
  return join([line, e, s, f], ' ')
endf
set foldtext=FoldText()

if exists('&inccommand')
  " Show the effects of a command incrementally
  set inccommand=nosplit
endif

" }}}

" Editing {{{
set smarttab        " insert blanks according to shiftwidth
set expandtab       " use spaces instead of TAB
set softtabstop=-1  " the number of spaces that a TAB counts for
set shiftwidth=2    " the number of spaces of an indent
set shiftround      " round indent to multiple of shiftwidth with > and <

set autoindent      " copy indent from current line when starting a new line
set copyindent      " copy the structure of the existing lines indent when
                    " autoindenting a new line
set preserveindent  " Use :retab to clean up whitespace

set undofile        " keep undo history on undofile
set virtualedit=all " allow virtual editing in all modes

" t - auto-wrap text using textwidth
" c - auto-wrap comments using textwidth, inserting the
"     current comment leader automatically
" r - automatically insert the current comment leader after
"     hitting <Enter> in Insert mode
" o - automatically insert the current comment leader after
"     hitting o in Insert mode
" n - when formatting text, recognize numbered lists
" l - long lines are not broken in insert mode
" m - also break at a multi-byte character above 255.
" B - when joining lines, don't insert a space between two
"     multi-byte characters
" j - where it make sense, remove a comment leader when
"     joining lines
set formatoptions+=r
set formatoptions+=o
set formatoptions+=n
set formatoptions+=m
set formatoptions+=B
set formatoptions+=j

" use clipboard register
" - unnamed     : 'selection' in X11; clipboard in Mac OS X and Windows
" - unnamedplus : 'clipboard' in X11, Mac OS X, and Windows (but yank)
set clipboard=unnamed,unnamedplus
if has('win32') || has('win64') || has('mac')
  set clipboard-=unnamedplus
endif

" completion settings
set complete& complete-=i,d
set completeopt&
set completeopt-=preview
set completeopt+=menu,longest
set pumheight=20        " height of popup menu
set showfulltag         " show both the tag name and the search pattern

" K to search the help with the cursor word
set keywordprg=:help
" }}}

" Mapping {{{
" :help insert-index

" define <Leader> and <LocalLeader>
noremap <Leader>      <Nop>
noremap <LocalLeader> <Nop>
let g:mapleader = ','
let g:maplocalleader = ','

" Disable dengerous/annoying mappings
" ZZ - save and close Vim
" ZQ - close Vim
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>
noremap <MiddleMouse>   <Nop>
noremap <2-MiddleMouse> <Nop>
noremap <3-MiddleMouse> <Nop>
noremap <4-MiddleMouse> <Nop>

" Swap ; and : in Normal and Visual mode [US keyboard]
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;

" Emacs like movement in Insert/Command
noremap! <C-a> <Home>
noremap! <C-e> <End>
noremap! <C-f> <Right>
noremap! <C-b> <Left>
noremap! <C-d> <Del>

" Use Ctrl-f/b in Normal as well
noremap <C-f> <Right>
noremap <C-b> <Left>

" Better <C-n>/<C-p> in Command
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <Up>   <C-p>
cnoremap <Down> <C-n>

" Fix unreasonable mappings by historical reason
nnoremap vv 0v$
nnoremap Y y$

" Cursor movement for Japanese
nnoremap <silent><expr> j  v:count == 0 ? 'gj' : 'j'
nnoremap <silent><expr> k  v:count == 0 ? 'gk' : 'k'
nnoremap <silent><expr> gj v:count == 0 ? 'j' : 'gj'
nnoremap <silent><expr> gk v:count == 0 ? 'k' : 'gk'

" Window resize operations with <S-Arrow>
nnoremap <S-Left>  <C-w><<CR>
nnoremap <S-Right> <C-w>><CR>
nnoremap <S-Up>    <C-w>-<CR>
nnoremap <S-Down>  <C-w>+<CR>

" Tab navigation
nnoremap <silent> <C-w>t :<C-u>tabnew<CR>
nnoremap <silent> <C-w><C-t> :<C-u>tabnew<CR>
nnoremap <silent> <C-w>q :<C-u>tabclose<CR>
nnoremap <silent> <C-w><C-q> :<C-u>tabclose<CR>
nnoremap <C-n> gt
nnoremap <C-p> gT

" Clear highlight with <C-l>
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>

" Jump to next/previous errors
nnoremap <silent><expr> ]c &diff ? ']c' : ":\<C-u>cnext\<CR>"
nnoremap <silent><expr> [c &diff ? ']c' : ":\<C-u>cprevious\<CR>"
nnoremap <silent> ]l :\<C-u>lnext<CR>
nnoremap <silent> [l :\<C-u>lprevious<CR>

" Easy window navigation
nmap <Space>w <C-w>
nnoremap <Space>n gt
nnoremap <Space>p gT

" Paste from a most recent yank text ("0 register)
nnoremap <Space>p "0p
nnoremap <Space>P "0P

" Execute a macro over a visual range with @ {{{
function! s:execute_macro_over_visual_range() abort
  execute ":'<,'>normal @" . nr2char(getchar())
endfunction
xnoremap <silent> <Plug>(my-execute-macro)
      \ :<C-u>call <SID>execute_macro_over_visual_range()<CR>
xmap @ <Plug>(my-execute-macro)
" }}}

" Toggle quickfix window with Q {{{
function! s:toggle_qf() abort
  let nwin = winnr('$')
  cclose
  if nwin == winnr('$')
    botright copen
  endif
endfunction
nnoremap <silent> <Plug>(my-toggle-quickfix)
      \ :<C-u>call <SID>toggle_qf()<CR>
nmap Q <Plug>(my-toggle-quickfix)
" }}}

" Toggle location list window with L {{{
function! s:toggle_ll() abort
  let nwin = winnr('$')
  lclose
  if nwin == winnr('$')
    botright lopen
  endif
endfunction
nnoremap <silent> <Plug>(my-toggle-locationlist)
      \ :<C-u>call <SID>toggle_ll()<CR>
nmap L <Plug>(my-toggle-locationlist)
" }}}

" Switch options with S {{{
let s:switch_allowed_options = [
      \ 'spell',
      \ 'wrap',
      \ 'expandtab',
      \ 'list',
      \ 'scrollbind',
      \ 'paste',
      \ 'preview',
      \]
function! s:switch_option() abort
  echohl Question
  call inputsave()
  try
    redraw
    let fname = s:get_function_name(function('s:switch_option_complete'))
    let candidates = s:switch_option_complete(
          \ input('Switch: ', '', 'customlist,' . fname), '', 0
          \)
    if empty(candidates)
      echohl WarningMsg
      echo 'Canceled.'
    endif
    call s:switch_option_handle(candidates[0])
  finally
    echohl None
    call inputrestore()
  endtry
endfunction

function! s:switch_option_handle(name) abort
  if a:name ==# 'preview'
    if &completeopt =~# 'preview'
      setlocal completeopt-=preview
      redraw | echo '-preview'
    else
      setlocal completeopt+=preview
      redraw | echo '+preview'
    endif
  else
    execute printf('setlocal %s! %s?', a:name, a:name)
  endif
endfunction

function! s:switch_option_complete(arglead, cmdline, cursorpos) abort
  return filter(
        \ copy(s:switch_allowed_options),
        \ 'v:val =~# ''^'' . a:arglead'
        \)
endfunction

if has('patch-7.4.1842')
  function! s:get_function_name(fn) abort
    return get(a:fn, 'name')
  endfunction
else
  function! s:get_function_name(fn) abort
    return matchstr(string(a:fn), 'function(''\zs.*\ze''')
  endfunction
endif

nnoremap <silent> <Plug>(my-switch-option) :<C-u>call <SID>switch_option()<CR>
nmap S <Plug>(my-switch-option)
" }}}

" Source Vim script file with <Leader><Leader>s {{{
if !exists('*s:source_script')
  function s:source_script(path) abort
    let path = expand(a:path)
    if !filereadable(path)
      return
    endif
    execute 'source' fnameescape(path)
    echo printf(
          \ '"%s" has sourced (%s)',
          \ simplify(fnamemodify(path, ':~:.')),
          \ strftime('%c'),
          \)
  endfunction
endif
nnoremap <silent> <Plug>(my-source-script)
      \ :<C-u>call <SID>source_script('%')<CR>
nmap <Leader><Leader>s <Plug>(my-source-script)
" }}}

" Switch colorscheme with <F3> {{{
let s:colorschemes = [
      \ 'hybrid',
      \ 'tender',
      \ 'iceberg',
      \ 'lucius',
      \ 'atom-dark',
      \]
let s:colorscheme_index = 0
function! s:set_colorscheme(index) abort
  let index = a:index is v:null
        \ ? float2nr(reltimefloat(reltime()))
        \ : a:index
  let s:colorscheme_index = index % len(s:colorschemes)
  let colorscheme_name = s:colorschemes[s:colorscheme_index]
  if colorscheme_name =~# '\%(tender\|hybrid\)'
    highlight Cursor guifg=white guibg=black
    highlight iCursor guifg=white guibg=steelblue
  endif
  execute 'colorscheme' colorscheme_name
  redraw | echo colorscheme_name
endfunction

function! s:switch_colorscheme(offset) abort
  call s:set_colorscheme(s:colorscheme_index + a:offset)
endfunction

nnoremap <silent> <Plug>(my-switch-colorscheme)
      \ :<C-u>call <SID>switch_colorscheme(1)<CR>
nmap <F3> <Plug>(my-switch-colorscheme)
" }}}

" Zoom widnow temporary with <C-w>o {{{
function! s:toggle_window_zoom() abort
    if exists('t:zoom_winrestcmd')
        execute t:zoom_winrestcmd
        unlet t:zoom_winrestcmd
    else
        let t:zoom_winrestcmd = winrestcmd()
        resize
        vertical resize
    endif
endfunction
nnoremap <silent> <Plug>(my-zoom-window)
      \ :<C-u>call <SID>toggle_window_zoom()<CR>
nmap <C-w>o <Plug>(my-zoom-window)
nmap <C-w><C-o> <Plug>(my-zoom-window)
"}}}

function! s:display_syninfo() abort
  let l = line('.')
  let c = col('.')
  echomsg printf('Hl: %s', synIDattr(synID(l, c, 1), 'name'))
  echomsg printf('Tr: %s', synIDattr(synID(l, c, 0), 'name'))
  echomsg printf('Lo: %s', synIDattr(synIDtrans(synID(l, c, 1)), 'name'))
endfunction
nnoremap <silent> <C-g>h :<C-u>call <SID>display_syninfo()<CR>

" }}}

" Macro {{{
" NOTE: Vim 7.4.1842 is required for get(Fn, 'name')
augroup MyAutoCmd
  autocmd!
augroup END

" Improve mkview/loadview {{{
" function! s:checkview() abort
"   if !&buflisted || &buftype =~# '^\%(nofile\|help\|quickfix\|terminal\)$' || &previewwindow
"     return 0
"   elseif &filetype =~# '^\%(vimfiler\|deoplete\)$'
"     return 0
"   endif
"   return 1
" endfunction
" autocmd MyAutoCmd BufWinLeave * if s:checkview() | silent! mkview   | endif
" autocmd MyAutoCmd BufWinEnter * if s:checkview() | silent! loadview | endif
" }}}

" Automatically remove trailing spaces {{{
function! s:remove_trailing_spaces_automatically() abort
  augroup remove_trailing_spaces_automatically
    autocmd! * <buffer>
    autocmd BufWritePre <buffer> %s/\s\+$//e
  augroup END
endfunction
augroup enable_remove_trailing_spaces_automatically
  execute printf(
        \ 'autocmd FileType %s call s:remove_trailing_spaces_automatically()',
        \ join(split(
        \   'perl python vim vimspec javascript typescript ' .
        \   'dosbatch ps1 sh iss pascal'
        \ ), ',')
        \)
augroup END
" }}}

" Automatically re-assign filetype {{{
autocmd MyAutoCmd BufWritePost *
      \ if &filetype ==# '' || exists('b:ftdetect') |
      \  unlet! b:ftdetect |
      \  filetype detect |
      \ endif
"}}}

" Automatically create missing directories {{{
function! s:auto_mkdir(dir, force) abort
  if empty(a:dir) || a:dir =~# '^\w\+://' || isdirectory(a:dir) || a:dir =~# '^sudo:'
      return
  endif
  if !a:force
    echohl Question
    call inputsave()
    try
      let result = input(
            \ printf('"%s" does not exist. Create? [y/N]', a:dir),
            \ '',
            \)
      if empty(result)
        echohl WarningMsg
        echo 'Canceled'
        return
      endif
    finally
      call inputrestore()
      echohl None
    endtry
  endif
  call mkdir(a:dir, 'p')
endfunction

function! s:auto_makedir_complete(...) abort
  return "yes\nno"
endfunction

autocmd MyAutoCmd BufWritePre *
      \ call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
" }}}

" Automatically change working directory on vim enter {{{
function! s:workon(dir, bang) abort
  let dir = (a:dir ==# '' ? expand('%') : a:dir)
  " convert filename to directory if required
  if filereadable(dir)
    let dir = fnamemodify(expand(dir),':p:h')
  else
    let dir = fnamemodify(dir, ':p')
  endif
  " change directory to specified directory
  if isdirectory(dir)
    silent execute 'cd ' . fnameescape(dir)
    if a:bang ==# ''
      redraw | echo 'Working on: '.dir
      if v:version > 703 || (v:version == 703 && has('patch438'))
        doautocmd <nomodeline> MyAutoCmd User my-workon-post
      else
        doautocmd MyAutoCmd User my-workon-post
      endif
    endif
  endif
endfunction
autocmd MyAutoCmd VimEnter * call s:workon(expand('<afile>'), 1)
command! -nargs=? -complete=dir -bang Workon call s:workon('<args>', '<bang>')
" }}}

" Automatically show cursorline when hold {{{
augroup vimrc-auto-cursorline
  autocmd!
  autocmd CursorMoved,CursorMovedI * call s:auto_cursorline('CursorMoved')
  autocmd CursorHold,CursorHoldI * call s:auto_cursorline('CursorHold')
  autocmd WinEnter * call s:auto_cursorline('WinEnter')
  autocmd WinLeave * call s:auto_cursorline('WinLeave')

  let s:cursorline_lock = 0
  function! s:auto_cursorline(event)
    if a:event ==# 'WinEnter'
      setlocal cursorline
      let s:cursorline_lock = 2
    elseif a:event ==# 'WinLeave'
      setlocal nocursorline
    elseif a:event ==# 'CursorMoved'
      if s:cursorline_lock
        if 1 < s:cursorline_lock
          let s:cursorline_lock = 1
        else
          setlocal nocursorline
          let s:cursorline_lock = 0
        endif
      endif
    elseif a:event ==# 'CursorHold'
      setlocal cursorline
      let s:cursorline_lock = 1
    endif
  endfunction
augroup END
" }}}

" Add runtimepath {{{
function! s:add_runtimepath() abort
  let path = getcwd()
  execute printf('set runtimepath^=%s', fnameescape(path))
  if isdirectory(path . '/plugin')
    for filename in glob(path . '/plugin/*.vim', 0, 1)
      execute printf('source %s', fnameescape(filename))
    endfor
  endif
  echo printf('"%s" is added to &runtimepath', path)
endfunction
command! AddRuntimePath call s:add_runtimepath()
" }}}

" Show runtimepath {{{
function! s:echo_runtimepath() abort
  for path in split(&runtimepath, ',')
    echo path
  endfor
endfunction
command! EchoRuntimePath call s:echo_runtimepath()
" }}}

" Check keycode {{{
function! s:getchar() abort
  redraw | echo 'Press any key: '
  let c = getchar()
  while c ==# "\<CursorHold>"
    redraw | echo 'Press any key: '
    let c = getchar()
  endwhile
  redraw | echo printf('Raw: "%s" | Char: "%s"', c, nr2char(c))
endfunction
command! GetChar call s:getchar()
" }}}

" Profile code {{{
function! s:timeit(command) abort
  let start = reltime()
  execute a:command
  let delta = reltime(start)
  echomsg '[timeit]' a:command
  echomsg '[timeit]' reltimestr(delta)
endfunction
command! -nargs=* Timeit call s:timeit(<q-args>)
" }}}

" Open terminal window {{{
if has('nvim')
  function! s:open_terminal_window() abort
    tabnew
    execute 'terminal'
    nnoremap <buffer><silent> q :<C-u>quit<CR>
  endfunction
else
  function! s:open_terminal_window() abort
    tabnew
    VimShell
    nmap <buffer><silent> q <Plug>(vimshell_exit)
  endfunction
endif
nnoremap <silent> T :<C-u>call <SID>open_terminal_window()<CR>
" }}}

" Enable sudo {{{
if has('nvim')
  function! s:sudo_write(path) abort
    let bufnr = bufnr('%')
    let path = fnamemodify(expand(a:path), ':p')
    let temp = tempname()
    let command = printf(
          \ 'sudo true | cat "%s" | sudo tee "%s" >/dev/null && rm "%s"',
          \ temp, path, temp
          \)
    call writefile(getline(1, '$'), temp)
    execute printf('%s %dnew', 'belowright', 5)
    setlocal bufhidden=wipe
    augroup sudo_write
      autocmd! * <buffer>
      execute printf(
            \ 'autocmd BufWipeout <buffer> call setbufvar(%d, "&modified", 0)',
            \ bufnr,
            \)
    augroup END
    execute printf('term %s', command)
  endfunction
  command! -nargs=1 SudoWrite call s:sudo_write(<q-args>)
  cnoreabbrev w!! call <SID>sudo_write('%')<CR>
else
  cnoreabbrev w!! w !sudo tee % >/dev/null
endif
" }}}

" Enhance performance {{{
" Removing guibg enhance performance on Alacritty
" Ref: https://github.com/jwilm/alacritty/issues/660#issuecomment-315239034
if has('nvim')
  function! s:performance_enhancer(args) abort
    if empty(a:args)
      let s:performance_enhancer_enabled = !s:performance_enhancer_enabled
    elseif a:args =~# '^\%(enable\|on\)$'
      let s:performance_enhancer_enabled = 1
    else
      let s:performance_enhancer_enabled = 0
    endif
    if s:performance_enhancer_enabled
      augroup alacritty_enhance_performance
        autocmd! *
        autocmd ColorScheme * highlight Normal guibg=NONE
      augroup END
      highlight Normal guibg=None
    else
      augroup alacritty_enhance_performance
        autocmd! *
      augroup END
      execute 'colorscheme' get(g:, 'colors_name', 'default')
    endif
  endfunction

  let s:performance_enhancer_enabled = 0
  command! -nargs=? PerformanceEnhancer call s:performance_enhancer(<q-args>)
endif
" }}}

" }}}

" Terminal {{{
if has('nvim')
  " Use <ESC> to escape from terminal mode
  tnoremap <Esc> <C-\><C-n>
  tnoremap g<Esc> <Esc>

  " Configure terminal buffer
  function! s:configure_terminal() abort
    setlocal nofoldenable
    setlocal foldcolumn=0
    setlocal nonumber
    setlocal norelativenumber
  endfunction
  autocmd MyAutoCmd TermOpen * call s:configure_terminal()
endif
" }}}

" Patch {{{

" Enhance performance of scroll in vsplit mode via DECSLRM {{{
" NOTE: Neovim (libvterm) already support it but Vim
" Ref: http://qiita.com/kefir_/items/c725731d33de4d8fb096
" Ref: https://github.com/neovim/libvterm/commit/04781d37ce5af3f580376dc721bd3b89c434966b
" Ref: https://twitter.com/kefir_/status/541959767002849283
if has('vim_starting') && !has('gui_running') && !has('nvim')
  " Enable origin mode and left/right margins
  function! s:enable_vsplit_mode() abort
    let &t_CS = 'y'
    let &t_ti = &t_ti . "\e[?6;69h"
    let &t_te = "\e[?6;69l\e[999H" . &t_te
    let &t_CV = "\e[%i%p1%d;%p2%ds"
    call writefile(["\e[?6;69h"], '/dev/tty', 'a')
  endfunction

  " Old vim does not ignore CPR
  map <special> <Esc>[3;9R <Nop>

  " New vim can't handle CPR with direct mapping
  " map <expr> ^[[3;3R <SID>enable_vsplit_mode()
  set t_F9=[3;3R
  map <expr> <t_F9> <SID>enable_vsplit_mode()
  let &t_RV .= "\e[?6;69h\e[1;3s\e[3;9H\e[6n\e[0;0s\e[?6;69l"
endif
" }}}

" }}}

" Plugin {{{
let s:bundle_root = expand('~/.cache/dein')
let s:bundle_dein = s:join(s:bundle_root, 'repos/github.com/Shougo/dein.vim')
if isdirectory(s:bundle_dein) && s:plugin_enabled
  if has('vim_starting')
    execute 'set runtimepath^=' . fnameescape(s:bundle_dein)
  endif
  if dein#load_state(s:bundle_root)
    call dein#begin(s:bundle_root, [
          \ s:join(s:config_root, 'init.vim'),
          \ s:join(s:config_root, 'rc.d', 'dein.toml'),
          \])
    call dein#load_toml(s:join(s:config_root, 'rc.d', 'dein.toml'))
    call dein#local(expand('~/Code/github.com/lambdalisue'))
    call dein#end()
    call dein#save_state()
  endif
  if !has('vim_starting')
    call dein#call_hook('source')
    call dein#call_hook('post_source')
  endif
else
  function! s:install() abort
    if !executable('git')
      echohl ErrorMsg
      echo '"git" is not executable. You need to install "git" first.'
      echohl None
      return 1
    endif

    echo 'Installing Shougo/dein.vim ...'
    " Check if a parent directory is available and make if not
    let parent_directory = fnamemodify(s:bundle_dein, ':h')
    if !isdirectory(parent_directory)
      call mkdir(parent_directory, 'p')
    endif
    call system(printf(
          \ 'git clone %s %s',
          \ 'https://github.com/Shougo/dein.vim',
          \ fnameescape(s:bundle_dein),
          \))
    echo 'Shougo/dein.vim has installed. Restart your Vim.'
  endfunction
  command! Install call s:install()
  echo 'Use ":Install" to install "Shougo/dein.vim"'
endif
" }}}

" Postludium {{{
" Make sure required directories exist
call s:auto_mkdir(&viewdir, 1)
call s:auto_mkdir(&undodir, 1)
call s:auto_mkdir(fnamemodify(&spellfile, ':p:h'), 1)

filetype indent plugin on
syntax on
set background=dark
try
  silent call s:set_colorscheme(0)
catch
  colorscheme desert
endtry

" Source '~/.vimrc.local' only when exists
" This requires to be posterior to Plugin loading
silent call s:source_script('~/.vimrc.local')

set secure
" }}}
"-----------------------------------------------------------------------------
" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker
