scriptencoding utf-8

augroup MyAutoCmdForDein
  autocmd! *
augroup END

function! s:is_git_available()
  if !executable('git')
    return 0
  endif
  if dein#is_sourced('vim-gita')
    return gita#is_enabled()
  elseif dein#is_sourced('vimproc')
    call vimproc#system('git rev-parse')
    return (vimproc#get_last_status() == 0) ? 1 : 0
  else
    call system('git rev-parse')
    return (v:shell_error == 0) ? 1 : 0
  endif
endfunction

function! s:register_on_source_hook(...) abort
  let fname = get(a:000, 0, printf(
        \ 's:%s_on_source',
        \ substitute(g:dein#name, '[-.]', '_', 'g'),
        \))
  execute printf(
        \ 'autocmd MyAutoCmdForDein User dein#source#%s call %s()',
        \ g:dein#name, fname,
        \)
endfunction

function! s:register_on_post_source_hook(...) abort
  let fname = get(a:000, 0, printf(
        \ 's:%s_on_post_source',
        \ substitute(g:dein#name, '[-.]', '_', 'g'),
        \))
  execute printf(
        \ 'autocmd MyAutoCmdForDein User dein#post_source#%s call %s()',
        \ g:dein#name, fname,
        \)
endfunction

" Fundemental ----------------------------------------------------------------

if dein#tap('sudo.vim') " {{{
  cnoreabbr w!! :w sudo:%
endif " }}}

if dein#tap('vim-template') " {{{
  function! s:template_call() abort
    " evaluate {CODE} in <%={CODE}=> and replace
    silent %s/<%=\(.\{-}\)%>/\=eval(submatch(1))/ge
    " move the cursor into <+CURSOR+>
    if search('<+CURSOR+>', 'cw')
      silent execute 'normal! "_da>'
    endif
  endfunction
  autocmd MyAutoCmd User plugin-template-loaded call s:template_call()
endif " }}}

if dein#tap('vim-diffa') " {{{
  nmap <C-l> <Plug>(diffa-C-l)
endif " }}}

if dein#tap('vim-repeat') " {{{
  nmap .     <Plug>(repeat-.)
  nmap u     <Plug>(repeat-u)
  nmap U     <Plug>(repeat-U)
  nmap <C-r> <Plug>(repeat-<C-r>)
  nmap g-    <Plug>(repeat-g-)
  nmap g+    <Plug>(repeat-g+)
endif " }}}

if dein#tap('vim-quickhl') " {{{
  map H <Plug>(operator-quickhl-manual-this-motion)
endif " }}}

if dein#tap('open-browser.vim') " {{{
  let g:netrw_nogx = 1 " disable netrw's gx mapping
  nmap gx <Plug>(openbrowser-smart-search)
  vmap gx <Plug>(openbrowser-smart-search)
endif " }}}

if dein#tap('vim-fullscreen') " {{{
  nmap <C-CR> <Plug>(fullscreen-toggle)
endif " }}}

if dein#tap('vim-over') " {{{
  function! s:vim_over_on_source() abort
    let g:over_enable_auto_nohlsearch = 1
    let g:over_enable_cmd_window = 1
    if has('multi_byte') && $LANG !=# 'C'
      let g:over_command_line_prompt = '» '
    endif
    let g:over#command_line#search#enable_incsearch = 1
  endfunction
  call s:register_on_source_hook()

  " Use vim-over instead of builtin substitution
  " http://leafcage.hateblo.jp/entry/2013/11/23/212838
  cnoreabbrev <silent><expr>s getcmdtype() ==# ':' && getcmdline() =~# '^s'
        \ ? "OverCommandLine<CR><C-u>%s/<C-r>=get([], getchar(0), '')<CR>"
        \ : 's'
  cnoreabbrev <silent><expr>'<,'>s getcmdtype() ==# ':' && getcmdline() =~# "^'<,'>s"
        \ ? "'<,'>OverCommandLine<CR>s/<C-r>=get([], getchar(0), '')<CR>"
        \ : "'<,'>s"

endif " }}}

if dein#tap('clever-f.vim') " {{{
  function! s:clever_f_vim_on_source() abort
    let g:clever_f_smart_case = 1
    let g:clever_f_not_overwrite_standard_mappings = 1
  endfunction
  call s:register_on_source_hook()

  map f <Plug>(clever-f-f)
  map F <Plug>(clever-f-F)
  map T <Plug>(clever-f-T)
  map t <Plug>(clever-f-t)
endif " }}}

if dein#tap('vim-asterisk') " {{{
  map *   <Plug>(asterisk-*)
  map #   <Plug>(asterisk-#)
  map g*  <Plug>(asterisk-g*)
  map g#  <Plug>(asterisk-g#)
  map z*  <Plug>(asterisk-z*)
  map gz* <Plug>(asterisk-gz*)
  map z#  <Plug>(asterisk-z#)
  map gz# <Plug>(asterisk-gz#)
endif " }}}

if dein#tap('incsearch.vim') " {{{
  function! s:incsearch_vim_on_source() abort
    let g:incsearch#auto_nohlsearch = 1
  endfunction
  call s:register_on_source_hook()

  map / <Plug>(incsearch-forward)
  map ? <Plug>(incsearch-backward)
  map g/ <Plug>(incsearch-stay)
  map n <Plug>(incsearch-nohl-n)
  map N <Plug>(incsearch-nohl-N)

  if !empty(dein#get('asterisk.vim'))
    map *   <Plug>(incsearch-nohl)<Plug>(asterisk-*)
    map #   <Plug>(incsearch-nohl)<Plug>(asterisk-#)
    map g*  <Plug>(incsearch-nohl)<Plug>(asterisk-g*)
    map g#  <Plug>(incsearch-nohl)<Plug>(asterisk-g#)
    map z*  <Plug>(incsearch-nohl)<Plug>(asterisk-z*)
    map gz* <Plug>(incsearch-nohl)<Plug>(asterisk-gz*)
    map z#  <Plug>(incsearch-nohl)<Plug>(asterisk-z#)
    map gz# <Plug>(incsearch-nohl)<Plug>(asterisk-gz#)
  else
    map *  <Plug>(incsearch-nohl-*)
    map #  <Plug>(incsearch-nohl-#)
    map g* <Plug>(incsearch-nohl-g*)
    map g# <Plug>(incsearch-nohl-g#)
  endif
endif " }}}

if dein#tap('yankround.vim') " {{{
  function! s:yankround_vim_on_source() abort
    let g:yankround_use_region_hl = 0
  endfunction
  call s:register_on_source_hook()

  nmap p     <Plug>(yankround-p)
  nmap P     <Plug>(yankround-P)
  nmap gp    <Plug>(yankround-gp)
  nmap gP    <Plug>(yankround-gP)
  nmap <expr><C-p> yankround#is_active()
        \ ? "\<Plug>(yankround-prev)"
        \ : "\<Plug>(my-tab-prev)"
  nmap <expr><C-n> yankround#is_active()
        \ ? "\<Plug>(yankround-next)"
        \ : "\<Plug>(my-tab-next)"
endif " }}}

if dein#tap('vim-bookmarks') " {{{
  function! s:vim_bookmarks_on_source() abort
    let g:bookmark_auto_save = 1
    let g:bookmark_save_per_working_dir = 1
    let g:bookmark_highlight_lines = 0
    " use 'long' converter to show actual file path
    call unite#custom_source(
          \ 'vim_bookmarks',
          \ 'converters',
          \ 'converter_vim_bookmarks_long')
  endfunction
  call s:register_on_source_hook()

  nnoremap <Plug>(my-bookmark) <Nop>
  nmap M <Plug>(my-bookmark)
  vmap M <Plug>(my-bookmark)
  nmap <Plug>(my-bookmark)m <Plug>BookmarkToggle
  nmap <Plug>(my-bookmark)i <Plug>BookmarkAnnotate
  vmap <Plug>(my-bookmark)m <Plug>BookmarkToggle
  vmap <Plug>(my-bookmark)i <Plug>BookmarkAnnotate
  nmap <Plug>(my-bookmark)n <Plug>BookmarkNext
  nmap <Plug>(my-bookmark)p <Plug>BookmarkPrev
  nmap <Plug>(my-bookmark)a <Plug>BookmarkShowAll
  nmap <Plug>(my-bookmark)c <Plug>BookmarkClear
  nmap <Plug>(my-bookmark)x <Plug>BookmarkClearAll

  nmap ]m <Plug>BookmarkNext
  nmap [m <Plug>BookmarkPrev
endif " }}}

if dein#tap('vim-quickrun') " {{{
  function! s:vim_quickrun_on_source() abort
    let g:quickrun_config = get(g:, 'quickrun_config', {})
    let g:quickrun_config['_'] = {
          \ 'runner' : 'vimproc',
          \ 'outputter/buffer/split': ':botright 8sp',
          \ 'outputter/buffer/close_on_empty': 1,
          \ 'hook/time/enable': 1,
          \}
    let g:quickrun_config['pyrex'] = {
          \ 'command': 'cython',
          \}
    " Terminate the quickrun with <C-c>
    nnoremap <expr><silent> <C-c> quickrun#is_running()
          \ ? quickrun#sweep_sessions() : "\<C-c>"
  endfunction
  call s:register_on_source_hook()

  nmap <LocalLeader>r <Plug>(quickrun)
endif " }}}

if dein#tap('vim-qfreplace') " {{{
  " use 'r' to call Qfreplace in QuickFix
  autocmd MyAutoCmd FileType qf nnoremap <buffer><silent> r
        \ :<C-u>Qfreplace<CR>
endif " }}}

if dein#tap('switch.vim') " {{{
  nmap \ :<C-u>Switch<CR>
endif " }}}

if dein#tap('linediff.vim') " {{{
endif " }}}

if dein#tap('vim-swap') " {{{
  function! s:vim_swap_on_source() abort
    let g:swap_enable_default_keymaps = 0
  endfunction
  call s:register_on_source_hook()

  nnoremap <Plug>(my-swap) <Nop>
  vnoremap <Plug>(my-swap) <Nop>
  nmap ~ <Plug>(my-swap)
  vmap ~ <Plug>(my-swap)
  vmap <Plug>(my-swap)~  <Plug>SwapSwapOperands
  vmap <Plug>(my-swap)-  <Plug>SwapSwapPivotOperands
  nmap <Plug>(my-swap)~  <Plug>SwapSwapWithR_WORD
  nmap <Plug>(my-swap)-  <Plug>SwapSwapWithL_WORD
endif " }}}

if dein#tap('vim-choosewin') " {{{
  nmap <C-w><C-w> <Plug>(choosewin)
endif " }}}

if dein#tap('vim-findent') " {{{
  augroup findent
    autocmd!
    autocmd FileType json,javascript    Findent --no-warnings
    autocmd FileType typescript         Findent --no-warnings
    autocmd FileType coffeescript       Findent --no-warnings
    autocmd FileType css,scss,sass,less Findent --no-warnings
    autocmd FileType xml,html           Findent --no-warnings
    autocmd FileType perl,python,ruby   Findent --no-warnings
  augroup END
endif " }}}

if dein#tap('vim-trip') " {{{
  nmap <C-a> <Plug>(trip-increment)
  nmap <C-x> <Plug>(trip-decrement)
endif " }}}

if dein#tap('vim-altr') " {{{
  nmap <F2> <Plug>(altr-forward)
endif " }}}

if dein#tap('vim-foldround') " {{{
  function! s:vim_foldround_on_source() abort
    call foldround#register('\.vim$', [
          \ 'syntax', 'marker',
          \])
    call foldround#register('\.vim/.*\.vim$', [
          \ 'syntax', 'marker',
          \])
    call foldround#register('[./]g\?vimrc$', [
          \ 'syntax', 'marker',
          \])
  endfunction
  call s:register_on_source_hook()
  nmap <C-f>f     <Plug>(foldround-forward)
  nmap <C-f><C-f> <Plug>(foldround-forward)
  nmap <C-f>b     <Plug>(foldround-backward)
  nmap <C-f><C-b> <Plug>(foldround-backward)
endif " }}}


" Completion -----------------------------------------------------------------

if dein#tap('neocomplete.vim') " {{{
  function! s:neocomplete_vim_on_source() abort
    let g:neocomplete#enable_at_startup = 1
    let g:neocomplete#enable_smart_case = 1
    let g:neocomplete#enable_fuzzy_completion = 0
    let g:neocomplete#force_omni_input_patterns = extend(
          \ get(g:, 'neocomplete#force_omni_input_patterns', {}), {
          \   'python': '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*',
          \})
    let g:neocomplete#disable_auto_complete = 1
  endfunction
  call s:register_on_source_hook()

  inoremap <silent><expr><C-x><C-x> neocomplete#start_manual_complete()
  inoremap <expr><CR> (pumvisible() ? "\<C-y>" : "") . "\<CR>"
endif " }}}

if dein#tap('deoplete.nvim') " {{{
  function! s:deoplete_nvim_on_source() abort
    let g:deoplete#enable_at_startup = 1
    let g:deoplete#enable_smart_case = 1
    let g:deoplete#enable_fuzzy_completion = 0
    let g:deoplete#force_omni_input_patterns = extend(
          \ get(g:, 'deoplete#force_omni_input_patterns', {}), {
          \   'python': '\v%([^. \t].|^\s*@|^\s*from\s.+import |^\s*from |^\s*import )\w*',
          \})
    let g:deoplete#disable_auto_complete = 1
  endfunction
  call s:register_on_source_hook()

  inoremap <silent><expr><C-x><C-x> deoplete#mappings#manual_complete()
  inoremap <expr><CR> (pumvisible() ? "\<C-y>" : "") . "\<CR>"
endif " }}}

if dein#tap('neosnippet.vim') " {{{
  function! s:neosnippet_vim_on_source() abort
    let g:neosnippet#snippets_directory = expand('$MYVIM_HOME/snippets')
    let g:neosnippet#enable_snipmate_compatibility = 1

    " for snippet complete marker
    if has('conceal')
      setglobal conceallevel=2 concealcursor=niv
    endif
  endfunction
  call s:register_on_source_hook()

  " Plugin key-mappings.
  if has('nvim')
    imap <expr><C-g> pumvisible()
          \ ? "\<Plug>(neosnippet_expand_or_jump)"
          \ : neosnippet#expandable_or_jumpable()
          \   ? "\<Plug>(neosnippet_expand_or_jump)"
          \   : deoplete#custom#manual_complete('neosnippet')
  elseif has('lua')
    imap <expr><C-g> pumvisible()
          \ ? "\<Plug>(neosnippet_expand_or_jump)"
          \ : neosnippet#expandable_or_jumpable()
          \   ? "\<Plug>(neosnippet_expand_or_jump)"
          \   : neocomplete#start_manual_complete('neosnippet')
  endif
  smap <C-g> <Plug>(neosnippet_expand_or_jump)
  xmap <C-g> <Plug>(neosnippet_expand_target)
endif " }}}

if dein#tap('echodoc.vim') " {{{
  function! s:echodoc_vim_on_source() abort
    setglobal cmdheight=2
    setglobal completeopt+=menuone
    "set completeopt-=preview
    let g:echodoc_enable_at_startup=1
  endfunction
  call s:register_on_source_hook()
endif " }}}


" Statusline -----------------------------------------------------------------

if dein#tap('lightline.vim') " {{{
  function! s:is_filelike() abort
    return &buftype =~# '^\|nowrite\|acwrite$'
  endfunction
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

  if !empty(dein#get('vim-gita'))
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
  else
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
  if !empty(dein#get('vim-pyenv'))
    function! g:lightline.my.pyenv() abort
      return dein#is_sourced('vim-pyenv')
            \ ? pyenv#info#preset('long') : ''
    endfunction
  else
    function! g:lightline.my.pyenv() abort
      return ''
    endfunction
  endif
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
endif " }}}

if dein#tap('vim-watchdogs') " {{{
  let g:watchdogs_check_CursorHold_enable = 0
  let g:watchdogs_check_BufWritePost_enable = 0
  let g:watchdogs_check_BufWritePost_enables = {
        \ 'vim': 1,
        \ 'zsh': 1,
        \ 'python': 1,
        \ 'perl': 1,
        \ 'javascript': 1,
        \ 'coffeescript': 1,
        \}
  let g:watchdogs_check_BufWritePost_enable_on_wq = 0

  let g:quickrun_config = get(g:, 'quickrun_config', {})
  let g:quickrun_config = extend(g:quickrun_config, {
        \ 'watchdogs_checker/_': {
        \   'runner/vimproc/updatetime': 40,
        \   'outputter/quickfix/open_cmd': '',
        \   'hook/qfstatusline_update/enable_exit': 1,
        \   'hook/qfstatusline_update/priority_exit': 4,
        \ }
        \})
  " use flake8 instead of pyflakes
  if executable('flake8')
    let g:quickrun_config['watchdogs_checker/pyflakes'] = {
        \ 'command': 'flake8',
        \}
  endif
  " use vint as a vimlint
  if executable('vint')
    let g:quickrun_config['watchdogs_checker/vint'] = {
          \ 'command': 'vint',
          \ 'exec'   : '%c %o %s:p',
          \}
    let g:quickrun_config['vim/watchdogs_checker'] = {
          \ 'type': 'watchdogs_checker/vint',
          \}
  endif
  call watchdogs#setup(g:quickrun_config)
endif " }}}

if dein#tap('vim-qfstatusline') " {{{
  let g:Qfstatusline#UpdateCmd = function('lightline#update')
endif " }}}


" Textobj --------------------------------------------------------------------

if dein#tap('vim-textobj-multiblock') " {{{
  omap ab <Plug>(textobj-multiblock-a)
  omap ib <Plug>(textobj-multiblock-i)
  xmap ab <Plug>(textobj-multiblock-a)
  xmap ib <Plug>(textobj-multiblock-i)
endif " }}}

if dein#tap('vim-textobj-python') " {{{
  function! s:vim_textobj_python_on_source() abort
    function! s:textobj_python_settings() abort
      xmap <buffer> aF <Plug>(textobj-python-function-a)
      omap <buffer> iF <Plug>(textobj-python-function-i)
      xmap <buffer> aC <Plug>(textobj-python-class-a)
      omap <buffer> iC <Plug>(textobj-python-class-i)
    endfunction
    autocmd MyAutoCmd FileType python call s:textobj_python_settings()
  endfunction
  call s:register_on_source_hook()
endif " }}}


" Operator -------------------------------------------------------------------

if dein#tap('vim-operator-replace') " {{{
  nmap R <Plug>(operator-replace)
  xmap R <Plug>(operator-replace)
endif " }}}

if dein#tap('vim-operator-trailingspace-killer') " {{{
  nmap <Plug>(my-operator)k <Plug>(operator-trailingspace-killer)
  xmap <Plug>(my-operator)k <Plug>(operator-trailingspace-killer)
endif " }}}

if dein#tap('vim-operator-surround') " {{{
  nmap sa <Plug>(operator-surround-append)
  nmap sd <Plug>(operator-surround-delete)
  nmap sr <Plug>(operator-surround-replace)
  xmap sa <Plug>(operator-surround-append)
  xmap sd <Plug>(operator-surround-delete)
  xmap sr <Plug>(operator-surround-replace)

  nmap sdd <Plug>(operator-surround-delete)<Plug>(textobj-multiblock-a)
  nmap srr <Plug>(operator-surround-replace)<Plug>(textobj-multiblock-a)
  xmap sdd <Plug>(operator-surround-delete)<Plug>(textobj-multiblock-a)
  xmap srr <Plug>(operator-surround-replace)<Plug>(textobj-multiblock-a)
endif " }}}

if dein#tap('vim-operator-breakline') " {{{
  nmap <Plug>(my-operator)b <Plug>(operator-breakline-manual)
  nmap <Plug>(my-operator)B <Plug>(operator-breakline-textwidth)
  xmap <Plug>(my-operator)b <Plug>(operator-breakline-manual)
  xmap <Plug>(my-operator)B <Plug>(operator-breakline-textwidth)
endif " }}}

if dein#tap('concealedyank.vim') " {{{
  nmap Y <Plug>(operator-concealedyank)
  xmap Y <Plug>(operator-concealedyank)
endif " }}}


" Interfaces -----------------------------------------------------------------

if dein#tap('ctrlp.vim') " {{{
  function! s:ctrlp_vim_on_source() abort
    let g:ctrlp_map = '<Nop>'
    let g:ctrlp_cmd = 'CtrlP'
    " Guess VCS root directory as well
    let g:ctrlp_working_path_mode = 'ra'
  endfunction
  call s:register_on_source_hook()
endif " }}}

if dein#tap('unite.vim') " {{{
  function! s:unite_vim_on_source() abort
    " grep
    if executable('hw')
      " Use hw (highway)
      " https://github.com/tkengo/highway
      let g:unite_source_grep_command = 'hw'
      let g:unite_source_grep_default_opts = '--no-group --no-color'
      let g:unite_source_grep_recursive_opt = ''
    elseif executable('ag')
      " Use ag (the silver searcher)
      " https://github.com/ggreer/the_silver_searcher
      let g:unite_source_grep_command = 'ag'
      let g:unite_source_grep_default_opts =
            \ '-i --vimgrep --hidden --ignore ' .
            \ '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
      let g:unite_source_grep_recursive_opt = ''
    elseif executable('pt')
      " Use pt (the platinum searcher)
      " https://github.com/monochromegane/the_platinum_searcher
      let g:unite_source_grep_command = 'pt'
      let g:unite_source_grep_default_opts = '--nogroup --nocolor'
      let g:unite_source_grep_recursive_opt = ''
    elseif executable('ack-grep')
      " Use ack
      " http://beyondgrep.com/
      let g:unite_source_grep_command = 'ack-grep'
      let g:unite_source_grep_default_opts =
            \ '-i --no-heading --no-color -k -H'
      let g:unite_source_grep_recursive_opt = ''
    elseif executable('jvgrep')
      " Use jvgrep
      " https://github.com/mattn/jvgrep
      let g:unite_source_grep_command = 'jvgrep'
      let g:unite_source_grep_default_opts =
            \ '-i --exclude ''\.(git|svn|hg|bzr)'''
      let g:unite_source_grep_recursive_opt = '-R'
    endif
    if !has('multi_byte') || $LANG ==# 'C'
      let config = {
            \ 'prompt': '> ',
            \ 'candidate_icon': ' ',
            \ 'marked_icon': '*',
            \}
    else
      let config = {
            \ 'prompt': '» ',
            \ 'candidate_icon': '⋮',
            \ 'marked_icon': '✓',
            \ 'no_hide_icon': 1,
            \}
    endif
    call unite#custom#profile('source/bookmark', 'context', {
          \ 'no_start_insert': 1,
          \})
    call unite#custom#profile('source/output', 'context', {
          \ 'no_start_insert': 1,
          \})
    call unite#custom#profile('source/giti', 'context', {
          \ 'no_start_insert': 1,
          \})
    call unite#custom#profile('source/menu', 'context', {
          \ 'no_start_insert': 1,
          \})
    call unite#custom#profile('default', 'context', extend(config, {
          \ 'start_insert': 1,
          \ 'no_empty': 1,
          \}))
    call unite#custom#default_action('directory', 'cd')
    call unite#custom#alias('file', 'edit', 'open')

    " agit.vim
    let agit = {
          \ 'description': 'open the directory (or parent directory) in agit',
          \ }
    function! agit.func(candidate) abort
      if isdirectory(a:candidate.action__path)
        let path = a:candidate.action__path
      else
        let path = fnamemodify(a:candidate.action__path, ':h')
      endif
      execute 'Agit' '--dir=' . path
    endfunction
    call unite#custom#action('file,cdable', 'agit', agit)
    let agit_file = {
          \ 'description': "open the file's history in agit.vim",
          \ }
    function! agit_file.func(candidate) abort
      execute 'AgitFile' '--file=' . a:candidate.action__path
    endfunction
    call unite#custom#action('file', 'agit_file', agit_file)

    function! s:configure_unite() abort
      let unite = unite#get_current_unite()

      " map 'r' to 'replace' or 'rename' action
      if get(unite, 'profile_name', '') ==# 'search'
        nnoremap <silent><buffer><expr><nowait> r
              \ unite#smart_map('r', unite#do_action('replace'))
      else
        nnoremap <silent><buffer><expr><nowait> r
              \ unite#smart_map('r', unite#do_action('rename'))
      endif

      " 'J' to select candidate instead of <Space> / <S-Space>
      silent! nunmap <buffer> <Space>
      silent! vunmap <buffer> <Space>
      silent! nunmap <buffer> <S-Space>
      nmap <buffer><nowait> J <Plug>(unite_toggle_mark_current_candidate)
      vmap <buffer><nowait> J <Plug>(unite_toggle_mark_selected_candidate)

      " 'E' to open right
      nnoremap <silent><buffer><expr><nowait> E
            \ unite#smart_map('E', unite#do_action('right'))

      " force winfixheight
      setlocal winfixheight
    endfunction
    autocmd MyAutoCmd FileType unite call s:configure_unite()

    function! s:register_filemenu(name, description, precursors) abort
      " find the length of the longest name
      let max_length = max(map(
            \ filter(deepcopy(a:precursors), 'len(v:val) > 1'),
            \ 'len(v:val[0])'
            \))
      let format = printf('%%-%ds : %%s', max_length)
      let candidates = []
      for precursor in a:precursors
        if len(precursor) == 1
          call add(candidates, [
                \ precursor[0],
                \ '',
                \])
        elseif len(precursor) >= 2
          let name = precursor[0]
          let desc = precursor[1]
          let path = get(precursor, 2, '')
          let path = resolve(expand(empty(path) ? desc : path))
          let kind = isdirectory(path) ? 'directory' : 'file'
          call add(candidates, [
                \ printf(format, name, desc),
                \ path,
                \])
        else
          let msg = printf(
                \ 'A candidate precursor must has 1 or more than two terms : %s',
                \ string(precursor)
                \)
          call add(candidates, [
                \ 'ERROR : ' . msg,
                \ '',
                \])
        endif
      endfor

      let menu = {}
      let menu.candidates = candidates
      let menu.description = a:description
      let menu.separator_length = max(map(
            \ deepcopy(candidates),
            \ 'len(v:val[0])',
            \))
      if menu.separator_length % 2 != 0
        let menu.separator_length += 1
      endif
      function! menu.map(key, value) abort
        let word = a:value[0]
        let path = a:value[1]
        if empty(path)
          if word ==# '-'
            let word = repeat('-', self.separator_length)
          else
            let length = self.separator_length - (len(word) + 3)
            let word = printf('- %s %s', word, repeat('-', length))
          endif
          return {
                \ 'word': '',
                \ 'abbr': word,
                \ 'kind': 'common',
                \ 'is_dummy': 1,
                \}
        else
          let kind = isdirectory(path) ? 'directory' : 'file'
          let directory = isdirectory(path) ? path : fnamemodify(path, ':h')
          return {
                \ 'word': word,
                \ 'abbr': printf('[%s] %s', toupper(kind[0]), word),
                \ 'kind': kind,
                \ 'action__path': path,
                \ 'action__directory': directory,
                \}
        endif
      endfunction

      " register to 'g:unite_source_menu_menus'
      let g:unite_source_menu_menus = get(g:, 'unite_source_menu_menus', {})
      let g:unite_source_menu_menus[a:name] = menu
    endfunction

    call s:register_filemenu('shortcut', 'Shortcut menu', [
          \ ['rook'],
          \ [
          \   'rook',
          \   '~/.homesick/repos/rook',
          \ ],
          \ ['vim'],
          \ [
          \   'vimrc',
          \   fnamemodify(resolve($MYVIMRC), ':~'),
          \ ],
          \ [
          \   'gvimrc',
          \   fnamemodify(resolve($MYGVIMRC), ':~'),
          \ ],
          \ [
          \   'vimshrc',
          \   '~/.vim/vimshrc',
          \ ],
          \ [
          \   'filetype.vim',
          \   fnamemodify(expand('$MYVIM_HOME/filetype.vim'), ':~'),
          \ ],
          \ [
          \   'vintrc.yaml',
          \   '~/.vintrc.yaml',
          \ ],
          \ [
          \   'autoload/vimrc.vim',
          \   fnamemodify(expand('$MYVIM_HOME/autoload/vimrc.vim'), ':~'),
          \ ],
          \ [
          \   'rc/mapping.vim',
          \   fnamemodify(expand('$MYVIM_HOME/rc/mapping.vim'), ':~'),
          \ ],
          \ [
          \   'rc/macro.vim',
          \   fnamemodify(expand('$MYVIM_HOME/rc/macro.vim'), ':~'),
          \ ],
          \ [
          \   'rc/plugin.vim',
          \   fnamemodify(expand('$MYVIM_HOME/rc/plugin.vim'), ':~'),
          \ ],
          \ [
          \   'rc/plugin.define.toml',
          \   fnamemodify(expand('$MYVIM_HOME/rc/plugin.define.toml'), ':~'),
          \ ],
          \ [
          \   'rc/plugin.config.vim',
          \   fnamemodify(expand('$MYVIM_HOME/rc/plugin.config.vim'), ':~'),
          \ ],
          \ [
          \   'rc/plugin/lightline.vim',
          \   fnamemodify(expand('$MYVIM_HOME/rc/plugin/lightline.vim'), ':~'),
          \ ],
          \ [
          \   'rc/plugin/unite.vim',
          \   fnamemodify(expand('$MYVIM_HOME/rc/plugin/unite.vim'), ':~'),
          \ ],
          \ [
          \   'rc/plugin/vimfiler.vim',
          \   fnamemodify(expand('$MYVIM_HOME/rc/plugin/vimfiler.vim'), ':~'),
          \ ],
          \ [
          \   'rc/plugin/vimshell.vim',
          \   fnamemodify(expand('$MYVIM_HOME/rc/plugin/vimshell.vim'), ':~'),
          \ ],
          \ [
          \   'vim',
          \   '~/.vim',
          \ ],
          \ [
          \   'bundle',
          \   '~/.vim/bundle',
          \ ],
          \ [
          \   'ftplugin',
          \   '~/.vim/ftplugin',
          \ ],
          \ ['zsh'],
          \ [
          \   'zshrc',
          \   '~/.config/zsh/.zshrc',
          \ ],
          \ [
          \   'rc/theme.dust.zsh',
          \   '~/.config/zsh/rc/theme.dust.zsh',
          \ ],
          \ [
          \   'rc/configure.applications.zsh',
          \   '~/.config/zsh/rc/configure.applications.zsh',
          \ ],
          \ [
          \   'zsh',
          \   '~/.config/zsh',
          \ ],
          \ ['tmux'],
          \ [
          \   'tmux.conf',
          \   '~/.tmux.conf',
          \ ],
          \ [
          \   'tmux-powerlinerc',
          \   '~/.tmux-powerlinerc',
          \ ],
          \ [
          \   'tmux-powerline.conf',
          \   '~/.config/tmux/tmux-powerline.conf',
          \ ],
          \ [
          \   'tmux',
          \   '~/.config/tmux',
          \ ],
          \ ['others'],
          \ [
          \   'gitconfig',
          \   '~/.gitconfig',
          \ ],
          \ [
          \   'gitignore',
          \   '~/.gitignore',
          \ ],
          \ [
          \   'pymolrc',
          \   '~/.pymolrc',
          \ ],
          \ [
          \   'vimperatorrc',
          \   '~/.vimperatorrc',
          \ ],
          \ [
          \   'latexmkrc',
          \   '~/.latexmkrc',
          \ ],
          \ [
          \   'jupyter custom.css',
          \   '~/.jupyter/custom/custom.css',
          \ ],
          \ [
          \   'jupyter custom.js',
          \   '~/.jupyter/custom/custom.js',
          \ ],
          \])
  endfunction
  call s:register_on_source_hook()

  " unite
  nnoremap <Plug>(my-unite) <Nop>
  nmap <Space> <Plug>(my-unite)
  vmap <Space> <Plug>(my-unite)

  nnoremap <silent> <Plug>(my-unite)<Space>
        \ :<C-u>UniteResume -no-start-insert<CR>
  nnoremap <silent> <Plug>(my-unite)w
        \ :<C-u>Unite buffer<CR>
  nnoremap <silent> <Plug>(my-unite)k
        \ :<C-u>Unite bookmark<CR>
  nnoremap <silent> <Plug>(my-unite)l :<C-u>Unite line
        \ -buffer-name=search<CR>
  nnoremap <silent> <Plug>(my-unite)h :<C-u>Unite help
        \ -buffer-name=search<CR>
  nnoremap <silent> <Plug>(my-unite)mp
        \ :<C-u>Unite output:map!<BAR>map<BAR>lmap
        \ -buffer-name=search<CR>
  vnoremap <silent> <Plug>(my-unite)l
        \ :<C-u>UniteWithCursorWord line
        \ -buffer-name=search<CR>
  vnoremap <silent> <Plug>(my-unite)h
        \ :<C-u>UniteWithCursorWord help
        \ -buffer-name=search<CR>

  " unite-menu
  nnoremap <silent> <Plug>(my-unite)s
        \ :<C-u>Unite menu:shortcut<CR>

  " unite-file
  nnoremap <Plug>(my-unite-file) <Nop>
  nmap <Plug>(my-unite)f <Plug>(my-unite-file)
  nnoremap <silent> <Plug>(my-unite-file)f
        \ :<C-u>call <SID>unite_smart_file()<CR>
  nnoremap <silent> <Plug>(my-unite-file)i
        \ :<C-u>Unite file<CR>
  nnoremap <silent> <Plug>(my-unite-file)m
        \ :<C-u>Unite file_mru<CR>
  nnoremap <silent> <Plug>(my-unite-file)r
        \ :<C-u>Unite file_rec/async<CR>
  nnoremap <silent> <Plug>(my-unite-file)g
        \ :<C-u>Unite file_rec/git<CR>
  function! s:unite_smart_file()
    if s:is_git_available()
      Unite file_rec/git
    else
      Unite file_rec/async
    endif
  endfunction

  " unite-directory
  nnoremap <Plug>(my-unite-directory) <Nop>
  nmap <Plug>(my-unite)d <Plug>(my-unite-directory)
  nnoremap <silent> <Plug>(my-unite-directory)d
        \ :<C-u>Unite directory_rec/async<CR>
  nnoremap <silent> <Plug>(my-unite-directory)i
        \ :<C-u>Unite directory<CR>
  nnoremap <silent> <Plug>(my-unite-directory)m
        \ :<C-u>Unite directory_mru<CR>
  nnoremap <silent> <Plug>(my-unite-directory)r
        \ :<C-u>Unite directory_rec/async<CR>

  " unite-qf
  nnoremap <Plug>(my-unite-qf) <Nop>
  nmap <Plug>(my-unite)q <Plug>(my-unite-qf)
  nnoremap <silent> <Plug>(my-unite-qf)q
        \ :<C-u>Unite quickfix location_list
        \ -buffer-name=search<CR>
  nnoremap <silent> <Plug>(my-unite-qf)f
        \ :<C-u>Unite quickfix
        \ -buffer-name=search<CR>
  nnoremap <silent> <Plug>(my-unite-qf)l
        \ :<C-u>Unite location_list
        \ -buffer-name=search<CR>

  " unite-grep
  nnoremap <Plug>(my-unite-grep) <Nop>
  nmap <Plug>(my-unite)g <Plug>(my-unite-grep)
  vmap <Plug>(my-unite)g <Plug>(my-unite-grep)
  nnoremap <silent> <Plug>(my-unite-grep)*
        \ :<C-u>UniteWithCursorWord grep:.
        \ -buffer-name=search
        \ -no-empty<CR>
  vnoremap <silent> <Plug>(my-unite-grep)*
        \ :UniteWithCursorWord grep:.
        \ -buffer-name=search
        \ -no-empty<CR>
  nnoremap <silent> <Plug>(my-unite-grep)g
        \ :<C-u>Unite grep:.
        \ -buffer-name=search
        \ -no-empty<CR>
  vnoremap <silent> <Plug>(my-unite-grep)g
        \ :Unite grep:.
        \ -buffer-name=search
        \ -no-empty<CR>
  nnoremap <silent> <Plug>(my-unite-grep)i
        \ :<C-u>Unite grep/git:/
        \ -buffer-name=search
        \ -no-empty<CR>
  vnoremap <silent> <Plug>(my-unite-grep)i
        \ :Unite grep/git:/
        \ -buffer-name=search
        \ -no-empty<CR>

  " unite-git
  nnoremap <Plug>(my-unite-git) <Nop>
  nmap <Plug>(my-unite)i <Plug>(my-unite-git)
  nnoremap <silent> <Plug>(my-unite-git)i
        \ :<C-u>Unite giti/branch_recent<CR>
  nnoremap <silent> <Plug>(my-unite-git)b
        \ :<C-u>Unite giti/branch_recent giti/branch_all<CR>
  nnoremap <silent> <Plug>(my-unite-git)r
        \ :<C-u>Unite giti/remote<CR>

  " unite-gista
  nnoremap <silent> <Plug>(my-unite-git)t
        \ :<C-u>Unite gista:lambdalisue<CR>

  " unite-ref
  nnoremap <Plug>(my-unite-ref) <Nop>
  nmap <Plug>(my-unite)r <Plug>(my-unite-ref)
  nnoremap <silent> <Plug>(my-unite-ref)r
              \ :<C-u>call <SID>unite_smart_ref()<CR>
  nnoremap <silent> <Plug>(my-unite-ref)p
              \ :<C-u>Unite ref/pydoc<CR>
  nnoremap <silent> <Plug>(my-unite-ref)l
              \ :<C-u>Unite perldoc<CR>
  nnoremap <silent> <Plug>(my-unite-ref)m
              \ :<C-u>Unite ref/man<CR>
  nnoremap <silent> <Plug>(my-unite-ref)j
              \ :<C-u>Unite ref/javascript<CR>
  nnoremap <silent> <Plug>(my-unite-ref)q
              \ :<C-u>Unite ref/jquery<CR>
  nnoremap <silent> <Plug>(my-unite-ref)k
              \ :<C-u>Unite ref/kotobank<CR>
  nnoremap <silent> <Plug>(my-unite-ref)w
              \ :<C-u>Unite ref/wikipedia<CR>
  function! s:unite_smart_ref()
    if &filetype =~# 'perl'
      Unite perldoc
    elseif &filetype =~# 'python'
      Unite ref/pydoc
    elseif &filetype =~# 'ruby'
      Unite ref/refe
    elseif &filetype =~# 'javascript'
      Unite ref/javascript
    elseif &filetype =~# 'vim'
      Unite help
    else
      Unite ref/man
    endif
  endfunction

  " unite-linephrase
  nnoremap <silent> <Plug>(my-unite)p
        \ :<C-u>Unite linephrase
        \ -no-quit -keep-focus -no-start-insert
        \ -buffer-name=search<CR>

  " unite-outline
  nnoremap <silent> <Leader>o
        \ :<C-u>Unite outline
        \ -no-quit -keep-focus -no-start-insert
        \ -vertical -direction=botright -winwidth=30<CR>

  " vim-bookmarks
  nnoremap <silent> <Plug>(my-unite)mm
        \ :<C-u>Unite vim_bookmarks
        \ -no-quit -keep-focus -no-start-insert
        \ -buffer-name=search<CR>

endif " }}}

if dein#tap('vimshell.vim') " {{{
  function! s:vimshell_vim_on_source() abort
    let zsh_history_path = expand('~/.config/zsh/.zsh_history')

    let g:vimshell_prompt = '$ '
    let g:vimshell_secondary_prompt = '| '
    if filereadable(zsh_history_path)
      let g:vimshell_external_history_path = zsh_history_path
    endif

    let s:vimshell_hooks = {}
    function! s:vimshell_hooks.chpwd(args, context) abort
      if len(split(glob('*'), '\n')) < 100
        call vimshell#execute('ls')
      else
        call vimshell#execute('echo "Many files."')
      endif
    endfunction
    function! s:vimshell_hooks.emptycmd(cmdline, context) abort
      call vimshell#execute('ls')
    endfunction
    function! s:vimshell_hooks.preexec(cmdline, context) abort
      let args = vimproc#parser#split_args(a:cmdline)
      if len(args) > 0 && args[0] ==# 'diff'
        call vimshell#set_syntax('diff')
      endif
      return a:cmdline
    endfunction

    function! s:configure_vimshell() abort
      " Initialize execute file list.
      call vimshell#set_execute_file('rb', 'ruby')
      call vimshell#set_execute_file('pl', 'perl')
      call vimshell#set_execute_file('py', 'python')
      call vimshell#set_execute_file('js', 'node')
      call vimshell#set_execute_file('coffee', 'coffee')

      if neobundle#is_installed('concealedyank')
        xmap <buffer> y <Plug>(operator-concealedyank)
      endif
      nmap <buffer><silent> q :<C-u>close<CR>
      imap <buffer> ^^ cd ..<CR>
      imap <buffer> [[ popd<CR>
      silent! iunmap <buffer> <C-n>
      silent! iunmap <buffer> <C-p>
      silent! nunmap <buffer> <C-n>
      silent! nunmap <buffer> <C-p>
      nmap <buffer> <Up>   <Plug>(vimshell-previous-prompt)
      nmap <buffer> <Down> <Plug>(vimshell-next-prompt)

      inoremap <buffer><silent><C-r> <Esc>:<C-u>Unite
            \ -buffer-name=history
            \ -default-action=execute
            \ -no-split
            \ vimshell/history vimshell/external_history<CR>
      inoremap <buffer><silent><C-x><C-j> <Esc>:<C-u>Unite
            \ -buffer-name=files
            \ -default-action=cd
            \ -no-split
            \ directory_mru<CR>

      call vimshell#hook#add('chpwd', 'my_chpwd', s:vimshell_hooks.chpwd)
      call vimshell#hook#add('emptycmd', 'my_emptycmd', s:vimshell_hooks.emptycmd)
      call vimshell#hook#add('preexec', 'my_preexec', s:vimshell_hooks.preexec)
    endfunction
    autocmd MyAutoCmd FileType vimshell call s:configure_vimshell()
  endfunction
  function! s:vimshell_vim_on_post_source() abort
    highlight! vimshellError gui=NONE cterm=NONE guifg='#cc6666' ctermfg=9
  endfunction
  call s:register_on_source_hook()
  call s:register_on_post_source_hook()

  nnoremap <Plug>(my-vimshell) <Nop>
  nmap s <Plug>(my-vimshell)
  nnoremap <silent> <Plug>(my-vimshell)s :<C-u>VimShell<CR>
  nnoremap <silent> <Plug>(my-vimshell)v :<C-u>VimShell -split -split-command=vsplit<CR>
  nnoremap <silent> <Plug>(my-vimshell)h :<C-u>VimShell -split -split-command=split<CR>
  nnoremap <silent> <Plug>(my-vimshell)t :<C-u>VimShellTab<CR>
endif " }}}

if dein#tap('vimfiler.vim') " {{{
  function! s:vimfiler_vim_on_source() abort
    let g:vimfiler_as_default_explorer = 1
    let g:vimfiler_ignore_pattern = printf('\%%(%s\)', join([
          \ '^\..*',
          \ '\.pyc$',
          \ '^__pycache__$',
          \ '\.egg-info$',
          \], '\|'))
    if has('multi_byte') && $LANG !=# 'C'
      let g:vimfiler_tree_leaf_icon =  '|'
      let g:vimfiler_tree_opened_icon = '-'
      let g:vimfiler_tree_closed_icon = '+'
      let g:vimfiler_file_icon = ' '
      let g:vimfiler_readonly_file_icon = '⭤'
      let g:vimfiler_marked_file_icon = '✓'
    endif

    call vimfiler#custom#profile('default', 'context', {
          \ 'auto_cd': 1,
          \ 'parent': 1,
          \ 'safe': 0,
          \ })

    function! s:configure_vimfiler() abort
      " use 'J' to select candidates instead of <Space> / <S-Space>
      silent! nunmap <buffer> <Space>
      silent! nunmap <buffer> <S-Space>
      silent! vunmap <buffer> <Space>
      nmap <buffer> J <Plug>(vimfiler_toggle_mark_current_line)
      vmap <buffer> J <Plug>(vimfiler_toggle_mark_selected_lines)
      " ^^ to go parent directory
      nmap <buffer> ^^ <Plug>(vimfiler_switch_to_parent_directory)
      " X to execute on the directory
      nmap <buffer> X
            \ <Plug>(vimfiler_switch_to_parent_directory)
            \ <Plug>(vimfiler_execute_system_associated)
            \ <Plug>(vimfiler_execute)
      " t to open tab
      nnoremap <buffer><silent> <Plug>(vimfiler_tab_edit_file)
            \ :<C-u>call vimfiler#mappings#do_action(b:vimfiler, 'tabopen')<CR>
      nmap <buffer> t <Plug>(vimfiler_tab_edit_file)
      " <Space>k to open bookmark
      nmap <buffer><silent> <Space>k :<C-u>Unite bookmark<CR>
    endfunction
    autocmd MyAutoCmd FileType vimfiler call s:configure_vimfiler()

    function! s:cd_all_vimfiler(path) abort
      let current_nr = winnr()
      try
        for winnr in filter(range(1, winnr('$')),
              \ "getwinvar(v:val, '&filetype') ==# 'vimfiler'")
          call vimfiler#util#winmove(winnr)
          call vimfiler#mappings#cd(a:path)
        endfor
      finally
        call vimfiler#util#winmove(current_nr)
      endtry
    endfunction
    autocmd MyAutoCmd User my-workon-post call s:cd_all_vimfiler(getcwd())

    " XXX: This is a work around
    " Note:
    "   Somehow, &winfixwidth of a buffer opened from VimFilerExplorer is set to
    "   1 and thus <C-w>= or those kind of command doesn't work.
    "   This work around stands for fixing that.
    function! s:force_nofixwidth() abort
      if empty(&buftype) || &buftype ==# '\v^%(nowrite|acwrite)$'
        setlocal nowinfixwidth
      endif
    endfunction
    autocmd MyAutoCmd BufWinEnter * call s:force_nofixwidth()
  endfunction
  call s:register_on_source_hook()

  nnoremap <Plug>(my-vimfiler) <Nop>
  nmap <Leader>e <Plug>(my-vimfiler)
  nnoremap <silent> <Plug>(my-vimfiler)e :<C-u>VimFilerExplorer<CR>
  nnoremap <silent> <Plug>(my-vimfiler)E :<C-u>VimFiler<CR>
endif " }}}

if dein#tap('undotree') " {{{
  nnoremap <Plug>(my-undotree) <Nop>
  nmap <Leader>u <Plug>(my-undotree)
  nnoremap <silent> <Plug>(my-undotree) :<C-u>UndotreeToggle<CR>
endif " }}}

if dein#tap('vim-ref') " {{{
  function! s:vim_ref_on_source() abort
    let g:ref_open = 'vsplit'
    function! s:ref_configure() abort
      nmap <buffer><silent> <C-p> <Plug>(ref-back)
      nmap <buffer><silent> <C-n> <Plug>(ref-forward)
    endfunction
    autocmd MyAutoCmd FileType ref call s:ref_configure()
  endfunction
  call s:register_on_source_hook()
endif " }}}

if dein#tap('ref-sources.vim') " {{{
  function! s:ref_sources_vim_on_source() abort
    let g:ref_jquery_doc_path     = expand('$MYVIM_HOME/bundle/jqapi')
    let g:ref_javascript_doc_path = expand('$MYVIM_HOME/bundle/jsref/htdocs')
    let g:ref_auto_resize = 1
    let g:ref_wikipedia_lang = ['ja', 'en']
  endfunction
  call s:register_on_source_hook()
endif " }}}

if dein#tap('tagbar') " {{{
  nnoremap <Plug>(my-tagbar) <Nop>
  nmap <Leader>t <Plug>(my-tagbar)
  nnoremap <silent> <Plug>(my-tagbar) :<C-u>TagbarToggle<CR>
endif " }}}

if dein#tap('memolist.vim') " {{{
  function! s:memolist_vim_on_source() abort
    let g:memolist_qfixgrep = 1
    let g:memolist_path = expand('~/Dropbox/Apps/Byword/')
    let g:memolist_unite = 1
    let g:memolist_unite_option = '-no-start-insert'
  endfunction
  call s:register_on_source_hook()

  nnoremap <Plug>(my-memolist) <Nop>
  nmap <Leader>m <Plug>(my-memolist)
  nnoremap <silent> <Plug>(my-memolist)m :<C-u>MemoList<CR>
  nnoremap <silent> <Plug>(my-memolist)n :<C-u>MemoNew<CR>
  nnoremap <silent> <Plug>(my-memolist)g :<C-u>MemoGrep<CR>
endif " }}}

if dein#tap('tabular') " {{{
  nnoremap <Plug>(my-tabular) <Nop>
  vnoremap <Plug>(my-tabular) <Nop>
  nmap <Leader>a <Plug>(my-tabular)
  vmap <Leader>a <Plug>(my-tabular)
  nnoremap <Plug>(my-tabular)= :<C-u>Tabularize /=<CR>
  vnoremap <Plug>(my-tabular)= :<C-u>Tabularize /=<CR>
  nnoremap <Plug>(my-tabular)> :<C-u>Tabularize /=><CR>
  vnoremap <Plug>(my-tabular)> :<C-u>Tabularize /=><CR>
  nnoremap <Plug>(my-tabular)# :<C-u>Tabularize /#<CR>
  vnoremap <Plug>(my-tabular)# :<C-u>Tabularize /#<CR>
  nnoremap <Plug>(my-tabular)! :<C-u>Tabularize /!<CR>
  vnoremap <Plug>(my-tabular)! :<C-u>Tabularize /!<CR>
  nnoremap <Plug>(my-tabular)" :<C-u>Tabularize /"<CR>
  vnoremap <Plug>(my-tabular)" :<C-u>Tabularize /"<CR>
  nnoremap <Plug>(my-tabular)& :<C-u>Tabularize /&<CR>
  vnoremap <Plug>(my-tabular)& :<C-u>Tabularize /&<CR>
  nnoremap <Plug>(my-tabular): :<C-u>Tabularize /:\zs<CR>
  vnoremap <Plug>(my-tabular): :<C-u>Tabularize /:\zs<CR>
  nnoremap <Plug>(my-tabular)<BAR> :<C-u>Tabularize /<BAR><CR>
  vnoremap <Plug>(my-tabular)<BAR> :<C-u>Tabularize /<BAR><CR>
endif " }}}

if dein#tap('vim-rengbang') " {{{
  function! s:vim_rengbang_on_source() abort
    let g:rengbang_default_pattern  = '\(\d\+\)'
    let g:rengbang_default_start    = 0
    let g:rengbang_default_step     = 1
    let g:rengbang_default_usefirst = 0
    let g:rengbang_default_confirm_sequence = [
          \ 'pattern',
          \ 'start',
          \ 'step',
          \ 'usefirst',
          \ 'format',
          \]
  endfunction
  call s:register_on_source_hook()

  nnoremap <Plug>(my-rengbang) <Nop>
  vmap <C-a> <Plug>(my-rengbang)
  vnoremap <Plug>(my-rengbang)a :<C-u>'<,'>RengBang<CR>
  vnoremap <Plug>(my-rengbang)A :<C-u>'<,'>RengBangUsePrev<CR>
  vnoremap <Plug>(my-rengbang)c :<C-u>'<,'>RengBangConfirm<CR>
  map <Plug>(my-operator)rr <Plug>(operator-rengbang)
  map <Plug>(my-operator)rR <Plug>(operator-rengbang-useprev)
endif " }}}

if dein#tap('colorizer') " {{{
  " Note:
  "   This plugin is quite heavy and it add BufEnter autocmd to visualize
  "   color thus should not be autoloaded with filetype or so on.
  function! s:colorizer_on_source() abort
    let g:colorizer_nomap = 1
  endfunction
  call s:register_on_source_hook()
endif " }}}

if dein#tap('calendar.vim') " {{{
  function! s:calendar_vim_on_source() abort
    let g:calendar_frame = 'default'
    let g:calendar_google_calendar = 1
    let g:calendar_google_task = 1
  endfunction
  call s:register_on_source_hook()

  nnoremap <Plug>(my-calendar) <Nop>
  nmap <Leader>c <Plug>(my-calendar)
  nnoremap <silent> <Plug>(my-calendar)c :<C-u>Calendar<CR>
  nnoremap <silent> <Plug>(my-calendar)t :<C-u>Calendar -view=clock<CR>
endif " }}}


" Unite sources --------------------------------------------------------------

if dein#tap('unite-linephrase') " {{{
  function! s:unite_linephrase_on_source() abort
    let g:linephrase#directory = expand('~/Dropbox/Apps/Vim/linephrase')
  endfunction
  call s:register_on_source_hook()
endif " }}}


" Version control system -----------------------------------------------------

if dein#tap('vim-gista') " {{{
  function! s:vim_gista_on_source() abort
    let g:gista#client#default_username = 'lambdalisue'
  endfunction
  call s:register_on_source_hook()
endif " }}}

if dein#tap('vim-gita') " {{{
  function! s:vim_gita_on_source() abort
    if executable('hub')
      let g:gita#executable = 'hub'
    endif
    let g:gita#command#browse#extra_translation_patterns = {
          \ 'ghe.admin.h': [
          \   [
          \     '\vhttps?://(%domain)/(.{-})/(.{-})%(\.git)?$',
          \     '\vgit://(%domain)/(.{-})/(.{-})%(\.git)?$',
          \     '\vgit\@(%domain):(.{-})/(.{-})%(\.git)?$',
          \     '\vssh://git\@(%domain)/(.{-})/(.{-})%(\.git)?$',
          \   ], {
          \     '_':     'https://\1/\2/\3/blob/%c1/%pt%{#L|}ls%{-L|}le',
          \     'exact': 'https://\1/\2/\3/blob/%r1/%pt%{#L|}ls%{-L|}le',
          \     'blame': 'https://\1/\2/\3/blame/%c1/%pt%{#L|}ls%{-L|}le',
          \   },
          \ ],
          \}
  endfunction
  call s:register_on_source_hook()

  nnoremap <Plug>(my-gita) <Nop>
  nmap <Leader>a <Plug>(my-gita)
  nnoremap <Plug>(my-gita)a :<C-u>Gita status  --ignore-submodules<CR>
  nnoremap <Plug>(my-gita)b :<C-u>Gita branch --all<CR>
  nnoremap <Plug>(my-gita)d :<C-u>Gita diff-ls --ignore-submodules origin/HEAD...<CR>
  nnoremap <Plug>(my-gita)l :<C-u>Gita ls<CR>
endif " }}}

if dein#tap('agit.vim') " {{{
  function! s:agit_vim_on_source() abort
    " add extra key-mappings
    function! s:my_agit_setting() abort
      nmap <buffer> ch <Plug>(agit-git-cherry-pick)
      nmap <buffer> Rv <Plug>(agit-git-revert)
    endfunction
    autocmd MyAutoCmd FileType agit call s:my_agit_setting()
  endfunction
  call s:register_on_source_hook()
endif " }}}


" Syntax ---------------------------------------------------------------------

if dein#tap('typescript-vim') " {{{
  function! s:typescript_vim_on_source() abort
    let g:typescript_indent_disable = 1
    let g:typescript_compiler_options = '-sourcemap'
  endfunction
  call s:register_on_source_hook()
endif " }}}


" Filetype specific ----------------------------------------------------------

if dein#tap('LaTeX-Box') " {{{
  function! s:LaTeX_Box_on_source() abort
    let g:LatexBox_latexmk_async = 1
    let g:LatexBox_latexmk_preview_continuously = 1
    let g:LatexBox_latexmk_options = '-pdfdvi'
    let g:LatexBox_build_dir = 'build'
    let g:LatexBox_Folding = 1
    let g:LatexBox_quickfix = 2
    let g:LatexBox_ignore_warnings = [
          \ 'Underfull', 'Overfull', 'specifier changed to',
          \ 'Module luatexbase-mcb warning: several functions in ',
          \ 'xparse/redefine-command',
          \ 'luatexja-preset warning: "scale"',
          \ 'Unsupported document class',
          \ '\setcatcoderange is deprecated',
          \ 'LaTeX Warning: You have requested document class',
          \ 'LaTeX Font Warning: Font shape',
          \ 'Package typearea Warning: Bad type area settings!',
          \ 'LaTeX Font Warning: Some font shapes were not available, defaults substituted.'
          \ ]
    " neocomplete should not used for tex
    let g:neocomplete#force_omni_input_patterns =
          \ get(g:, 'neocomplete#force_omni_input_patterns', {})
    let g:neocomplete#force_omni_input_patterns.tex =
          \ '\v(\\\a*(subref|ref|textcite|autocite|cite)\a*\{([^}]*,)?|\$)'

    function! s:latexbox_configure() abort
      imap <buffer> [[     \begin{
      imap <buffer> ]]     <Plug>LatexCloseCurEnv
      nmap <buffer> <F5>   <Plug>LatexChangeEnv
      vmap <buffer> <F7>   <Plug>LatexWrapSelection
      vmap <buffer> <S-F7> <Plug>LatexEnvWrapSelection
      imap <buffer> ((     \eqref{
    endfunction
    autocmd MyAutoCmd FileType tex,latex,plaintex call s:latexbox_configure()
  endfunction
  call s:register_on_source_hook()
endif " }}}

if dein#tap('vim-autopep8') " {{{
  function! s:vim_autopep8_on_source() abort
    let g:autopep8_disable_show_diff = 1
  endfunction
  call s:register_on_source_hook()
endif " }}}

if dein#tap('jedi-vim') " {{{
  function! s:jedi_vim_on_source() abort
    function! s:jedi_vim_configure() abort
      setlocal omnifunc=jedi#completions
      nmap <buffer> <LocalLeader>g <Plug>(jedi-goto-assignments)
      nmap <buffer> <LocalLeader>d <Plug>(jedi-goto-definitions)
      nmap <buffer> <LocalLeader>R <Plug>(jedi-rename)
      nmap <buffer> <LocalLeader>n <Plug>(jedi-usage)
      nmap <buffer> K <Plug>(jedi-show-documentation)
    endfunction
    autocmd MyAutoCmd FileType python call s:jedi_vim_configure()
  endfunction
  call s:register_on_source_hook()

  " jedi does not provide <Plug>(jedi-X) mappings
  nnoremap <silent> <Plug>(jedi-goto-assignments)
        \ :<C-u>call jedi#goto_assignments()<CR>
  nnoremap <silent> <Plug>(jedi-goto-definitions)
        \ :<C-u>call jedi#goto_definitions()<CR>
  nnoremap <silent> <Plug>(jedi-show-documentation)
        \ :<C-u>call jedi#show_documentation()<CR>
  nnoremap <silent> <Plug>(jedi-rename)
        \ :<C-u>call jedi#rename()<CR>
  nnoremap <silent> <Plug>(jedi-usages)
        \ :<C-u>call jedi#usages()<CR>
endif " }}}

if dein#tap('vim-pyenv') " {{{
  function! s:vim_pyenv_on_source() abort
    if jedi#init_python()
      function! s:jedi_auto_force_py_version() abort
        let major_version = pyenv#python#get_internal_major_version()
        call jedi#force_py_version(major_version)
      endfunction
      autocmd MyAutoCmd User vim-pyenv-activate-post   call s:jedi_auto_force_py_version()
      autocmd MyAutoCmd User vim-pyenv-deactivate-post call s:jedi_auto_force_py_version()
    endif
  endfunction
  call s:register_on_source_hook()
endif " }}}

if dein#tap('tsuquyomi') " {{{
  function! s:tsuquyomi_on_source() abort
    function! s:tsuquyomi_configure() abort
      nmap <buffer> <LocalLeader>d <Plug>(TsuquyomiDefinition)
      nmap <buffer> <LocalLeader>b <Plug>(TsuquyomiGoBack)
      nmap <buffer> <LocalLeader>r <Plug>(TsuquyomiReferences)
      nmap <buffer> <LocalLeader>R <Plug>(TsuquyomiRenameSymbolC)
      if exists('&ballooneval')
        setlocal ballooneval
        setlocal balloonexpr=tsuquyomi#balloonexpr()
      endif
    endfunction
    autocmd MyAutoCmd FileType typescript call s:tsuquyomi_configure()
  endfunction
  call s:register_on_source_hook()
endif " }}}

" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker
