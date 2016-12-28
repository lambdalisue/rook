"-----------------------------------------------------------------------------
" Prelude {{{
if has('vim_starting')
  " Sets the character encoding inside Vim.
  set encoding=utf-8
  scriptencoding utf-8

  " Use defaults.vim and revert several settings
  if filereadable(expand('$VIMRUNTIME/defaults.vim'))
    source $VIMRUNTIME/defaults.vim
  endif
  if has('vim_starting')
    set history=10000     " increate n of command line history
  endif
  set noruler             " [slow] do not show the cursor position.

  " Do not highlight string inside C comments.
  silent! unlet c_comment_strings

  " Use as many color as possible
  if !has('gui_running') && exists('&termguicolors')
    set termguicolors       " use truecolor in term
  endif
  if &term =~ '256color'
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

  " Disable unnecessary default plugins
  let g:loaded_gzip              = 1
  let g:loaded_tar               = 1
  let g:loaded_tarPlugin         = 1
  let g:loaded_zip               = 1
  let g:loaded_zipPlugin         = 1
  let g:loaded_rrhelper          = 1
  let g:loaded_2html_plugin      = 1
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
  let items = map(copy(a:000), 'matchstr(v:val, ''.\{-}/\?$'')')
  return join(items, '/')
endfunction

function! s:configure_path(name, pathlist) abort
  let pathlist = split(eval(a:name), ':')
  for path in map(filter(a:pathlist, '!empty(v:val)'), 'expand(v:val)')
    if isdirectory(path) && index(pathlist, path) == -1
      call insert(pathlist, path, 0)
    endif
  endfor
  execute printf('let %s = join(pathlist, '':'')', a:name)
endfunction

function! s:pick_path(pathlist, ...) abort
  for path in map(filter(a:pathlist, '!empty(v:val)'), 'resolve(expand(v:val))')
    if isdirectory(path)
      return path
    endif
  endfor
  return ''
endfunction
" }}}

" Environment {{{
call s:configure_path('$PATH', [
      \ '/usr/local/bin',
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
      \ '~/.cache/nvim/dein/repos/github.com/thinca/vim-themis/bin',
      \ '~/.cache/nvim/dein/repos/github.com/Kuniwak/vint/bin',
      \])
call s:configure_path('$MANPATH', [
      \ '/usr/local/share/man/',
      \])
let $PYENV_ROOT = s:pick_path([
      \ '~/.anyenv/envs/pyenv',
      \ '~/.pyenv',
      \])
set viewdir=~/.view
set undodir=~/.undo
set spellfile=~/Dropbox/Vim/system/spellfile.utf-8.add
" }}}

" Language {{{

" prefer English interface
language message C

" prefer English help
set helplang=en,ja

" set default language for spell check
" cjk - ignore spell check on Asian characters (China, Japan, Korea)
set nospell
set spelllang=en_us,cjk
set fileencodings=ucs-bom,utf-8,euc-jp,iso-2022-jp,cp932,utf-16,utf-16le
set fileformats=unix,dos,mac
" }}}

" Interface {{{
set emoji               " use double in unicode emoji
set hidden              " hide the buffer instead of close
set switchbuf=useopen   " use an existing buffer instaed of creating a new one

set showmatch           " highlight a partner of cursor character
set matchtime=1         " highlight a partner ASAP
set updatetime=500      " increase speed of CursorHold autocommand
set nostartofline       " let C-D, C-U,... to keep same column
set smartcase           " override the ignorecase if the search pattern contains
                        " upper case characters
set tagcase=match       " use case sensitive for tag
set hlsearch            " highlight found terms

set foldlevelstart=99
set foldnestmax=3       " maximum fold nesting level
set foldcolumn=3        " show fold guide


set laststatus=2        " always shows statusline
set showtabline=2       " always shows tabline
set report=0            " reports any changes
set cmdheight=2
set lazyredraw          " do not redraw while command execution

set splitright          " vsplit to right

set sessionoptions-=options

" https://ddrscott.github.io/blog/2016/sidescroll/
set sidescroll=1

" vertically split buffers for vimdiff
set diffopt& diffopt+=vertical

" move cursor previous/next line when the cursor is first/last character in the
" line and user move the cursor left/right
set whichwrap=b,s,<,>,~,[,]

" store cursor, folds, slash, and unix on view
set viewoptions=cursor,folds,slash,unix

" use rich completion system in command line
set wildmode=list:longest,full
set wildoptions=tagfile

set list          " show invisible characters
if $LANG !=# 'C'
  set listchars=tab:»-,trail:˽,extends:»,precedes:«,nbsp:%,eol:↵
  set showbreak=\ +
else
  set listchars=tab:>-,trail:-,extends:>,precedes:<,nbsp:%,eol:$
  set showbreak=\ +
endif
if exists('&breakindent')
  set breakindent   " every wrapped line will continue visually indented
endif

function! FoldText() abort
  let lnum = nextnonblank(v:foldstart)
  let line = lnum > v:foldend
        \ ? getline(v:foldstart)
        \ : substitute(getline(lnum), '\t', repeat(' ', &tabstop), 'g')
  let w = winwidth(0) - &foldcolumn - (&number || &relativenumber ? 8 : 0) - 5
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

" Easy window navigation
nmap <Space>w <C-w>
nnoremap <Space>n gt
nnoremap <Space>p gT

" Seemless substitution with :s<Space> {{{
cnoreabbrev <silent><expr>s getcmdtype() ==# ':' && getcmdline() =~# '^s'
      \ ? "%s/<C-r>=get([], getchar(0), '')<CR>"
      \ : 's'
cnoreabbrev <silent><expr>'<,'>s getcmdtype() ==# ':' && getcmdline() =~# "^'<,'>s"
      \ ? "'<,'>s/<C-r>=get([], getchar(0), '')<CR>"
      \ : "'<,'>s"
" }}}

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
      \ 'tender',
      \ 'hybrid',
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
function! s:checkview() abort
  if !&buflisted || &buftype =~# '^\%(nofile\|help\|quickfix\|terminal\)$' || &previewwindow
    return 0
  endif
  return 1
endfunction
autocmd MyAutoCmd BufWinLeave * if s:checkview() | silent! mkview   | endif
autocmd MyAutoCmd BufWinEnter * if s:checkview() | silent! loadview | endif
" }}}

" Automatically remove trailing spaces {{{
function! s:remove_trailing_spaces_automatically() abort
  augroup remove_trailing_spaces_automatically
    autocmd! * <buffer>
    autocmd BufWritePre <buffer> %s/\s\+$//e
  augroup END
endfunction
autocmd FileType perl,python,vim,vimspec,javascript,typescript
      \ call s:remove_trailing_spaces_automatically()
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
  if empty(a:dir) || a:dir =~# '^\w\+://' || isdirectory(a:dir)
      return
  endif
  if !a:force
    echohl Question
    call inputsave()
    try
      let result = input(
            \ printf('"%s" does not exist. Create? [y/N]', a:dir),
            \ '',
            \ 'custom,' . get(function('s:auto_mkdir_complete'), 'name')
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

" Automatically open a file with readonly mode when a swapfile exists {{{
function! s:open_readonly() abort
  let v:swapchoice = 'o'
  echohl WarningMsg
  echo 'A swap file is found. The file has opened in read-only mode.'
  echohl None
endfunction
autocmd MyAutoCmd SwapExists * call s:open_readonly()
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
  redraw | echo printf('Raw: %s | Char: %s', c, nr2char(c))
endfunction
command! GetChar call s:getchar()
" }}}

" Open terminal window {{{
if has('nvim')
  function! s:open_terminal_window() abort
    topleft 25 new
    terminal
    nnoremap <buffer><silent> q :<C-u>quit<CR>
  endfunction
else
  function! s:open_terminal_window() abort
    topleft 25 new
    VimShell
    nmap <buffer><silent> q <Plug>(vimshell_exit)
  endfunction
endif
nnoremap <silent> T :<C-u>call <SID>open_terminal_window()<CR>
" }}}

" }}}

" Symbols {{{
" NOTE:
" Most of the following symobls are defined in "Nerd Fonts"
" Install from https://github.com/ryanoasis/nerd-fonts#font-installation
if !has('multi_byte') || $LANG ==# 'C'
  let g:Symbols = {
        \ 'branch': '',
        \ 'readonly': '!',
        \ 'modified': '*',
        \ 'nomodifiable': '#',
        \ 'error': '!!! ',
        \ 'python': '# ',
        \ 'unix': 'unix',
        \ 'dos': 'dos',
        \ 'separator_left': '',
        \ 'separator_right': '',
        \}
else
  let g:Symbols = {
        \ 'branch': ' ',
        \ 'readonly': ' ',
        \ 'modified': ' ',
        \ 'nomodifiable': ' ',
        \ 'error': ' ',
        \ 'python': ' ',
        \ 'unix': ' ',
        \ 'dos': ' ',
        \ 'separator_left': '',
        \ 'separator_right': '',
        \}
endif
" }}}

" Terminal {{{
if has('nvim')
  " Use <ESC> to escape from terminal mode
  tnoremap <Esc> <C-\><C-n>

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

" Plugin {{{

" Source '~/.vimrc.local' only when exists
" This requires to be prior to Plugin loading
silent call s:source_script('~/.vimrc.local')

let s:bundle_root = expand('~/.cache/nvim/dein')
let s:bundle_dein = s:join(s:bundle_root, 'repos/github.com/Shougo/dein.vim')
if isdirectory(s:bundle_dein)
  if has('vim_starting')
    execute 'set runtimepath^=' . fnameescape(s:bundle_dein)
  endif
  if dein#load_state(s:bundle_root)
    call dein#begin(s:bundle_root, [
          \ expand('~/.config/nvim/init.vim'),
          \ expand('~/.config/nvim/rc.d/dein.toml'),
          \])
    call dein#load_toml(expand('~/.config/nvim/rc.d/dein.toml'))
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
  silent call s:set_colorscheme(v:null)
catch
  colorscheme desert
endtry

set secure
" }}}
"-----------------------------------------------------------------------------
" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker
