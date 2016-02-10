scriptencoding utf-8
noremap <Plug>(my-operator) <Nop>
map - <Plug>(my-operator)

function! s:is_git_available() "{{{
  if !executable('git')
    return 0
  endif
  if neobundle#is_sourced('vim-gita')
    return gita#is_enabled()
  else
    call vimproc#system('git rev-parse')
    return (vimproc#get_last_status() == 0) ? 1 : 0
  endif
endfunction "}}}

" fundementals {{{

if neobundle#tap('sudo.vim') " {{{
  function! neobundle#hooks.on_source(bundle) abort
    cabbr w!! :w sudo:%
  endfunction
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-template') " {{{
  function! neobundle#hooks.on_source(bundle) abort
    function! s:template_call() abort
      " evaluate {CODE} in <%={CODE}=> and replace
      silent %s/<%=\(.\{-}\)%>/\=eval(submatch(1))/ge
      " move the cursor into <+CURSOR+>
      if search('<+CURSOR+>', 'cw')
        silent execute 'normal! "_da>'
      endif
    endfunction
    autocmd MyAutoCmd User plugin-template-loaded call s:template_call()
  endfunction
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-unified-diff') && executable('git') " {{{
  function! neobundle#hooks.on_source(bundle) abort
    let unified_diff#arguments = [
          \   'diff',
          \   '--no-index',
          \   '--no-color',
          \   '--no-ext-diff',
          \   '--unified=0',
          \   '--histogram',
          \ ]
    set diffexpr=unified_diff#diffexpr()
  endfunction
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-repeat') " {{{
  " replace the builtin
  nmap .     <Plug>(repeat-.)
  nmap u     <Plug>(repeat-u)
  nmap U     <Plug>(repeat-U)
  nmap <C-r> <Plug>(repeat-<C-r>)
  nmap g-    <Plug>(repeat-g-)
  nmap g+    <Plug>(repeat-g+)
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-quickhl') " {{{
  nnoremap <Plug>(my-quickhl) <Nop>
  vnoremap <Plug>(my-quickhl) <Nop>
  xnoremap <Plug>(my-quickhl) <Nop>
  nmap <C-h> <Plug>(my-quickhl)
  vmap <C-h> <Plug>(my-quickhl)
  xmap <C-h> <Plug>(my-quickhl)

  nmap <Plug>(my-quickhl)h <Plug>(quickhl-manual-this)
  vmap <Plug>(my-quickhl)h <Plug>(quickhl-manual-this)
  xmap <Plug>(my-quickhl)h <Plug>(quickhl-manual-this)
  nmap <Plug>(my-quickhl)r <Plug>(quickhl-manual-reset)
  vmap <Plug>(my-quickhl)r <Plug>(quickhl-manual-reset)
  xmap <Plug>(my-quickhl)r <Plug>(quickhl-manual-reset)

  nmap <Plug>(my-quickhl)H  <Plug>(quickhl-manual-toggle)
  vmap <Plug>(my-quickhl)H  <Plug>(quickhl-manual-toggle)
  xmap <Plug>(my-quickhl)H  <Plug>(quickhl-manual-toggle)
  nmap <Plug>(my-quickhl)c  <Plug>(quickhl-cword-toggle)
  vmap <Plug>(my-quickhl)c  <Plug>(quickhl-cword-toggle)
  nmap <Plug>(my-quickhl)t  <Plug>(quickhl-tag-toggle)
  vmap <Plug>(my-quickhl)t  <Plug>(quickhl-tag-toggle)

  map  <Plug>(my-operator)h <Plug>(operator-quickhl-manual-this-motion)

  call neobundle#untap()
endif " }}}

if neobundle#tap('open-browser.vim') " {{{
  function! neobundle#hooks.on_source(bundle) abort
    let g:netrw_nogx = 1  " disable netrw's gx mapping
  endfunction

  nnoremap <Plug>(my-openbrowser) <Nop>
  nmap gx <Plug>(my-openbrowser)
  vmap gx <Plug>(my-openbrowser)
  nmap <Plug>(my-openbrowser) <Plug>(openbrowser-smart-search)
  vmap <Plug>(my-openbrowser) <Plug>(openbrowser-smart-search)

  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-fullscreen') " {{{
  nmap <C-CR> <Plug>(fullscreen-toggle)
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-over') " {{{
  function! neobundle#hooks.on_source(bundle) abort
    let g:over_enable_auto_nohlsearch = 1
    let g:over_enable_cmd_window = 1
    let g:over#command_line#search#enable_incsearch = 1
  endfunction

  " Use vim-over instead of builtin substitution
  " http://leafcage.hateblo.jp/entry/2013/11/23/212838
  cnoreabb <silent><expr>s getcmdtype() ==# ':'
        \ ? 'OverCommandLine<CR><C-u>%s/'
        \ : 's'
  cnoreabb <silent><expr>'<,'>s getcmdtype() ==# ':'
        \ ? "'<,'>OverCommandLine<CR>s/"
        \ : "'<,'>s"

  call neobundle#untap()
endif " }}}

if neobundle#tap('clever-f.vim') " {{{
  function! neobundle#hooks.on_source(bundle) abort
    let g:clever_f_smart_case = 1
    let g:clever_f_not_overwrite_standard_mappings = 1
  endfunction

  map f <Plug>(clever-f-f)
  map F <Plug>(clever-f-F)
  map T <Plug>(clever-f-T)
  map t <Plug>(clever-f-t)

  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-asterisk') " {{{
  call neobundle#untap()
endif " }}}

if neobundle#tap('incsearch.vim') " {{{
  function! neobundle#hooks.on_source(bundle) abort
    let g:incsearch#auto_nohlsearch = 1
    let g:incsearch#magic = '\v'
  endfunction

  map / <Plug>(incsearch-forward)
  map ? <Plug>(incsearch-backward)
  map g/ <Plug>(incsearch-stay)
  map n <Plug>(incsearch-nohl-n)
  map N <Plug>(incsearch-nohl-N)

  if neobundle#is_installed('asterisk.vim')
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

  call neobundle#untap()
endif " }}}

if neobundle#tap('yankround.vim') " {{{
  function! neobundle#hooks.on_source(bundle) abort
    let g:yankround_use_region_hl = 0
  endfunction

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

  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-bookmarks') " {{{
  function! neobundle#hooks.on_source(bundle) abort
    let g:bookmark_auto_save = 1
    let g:bookmark_save_per_working_dir = 1
    let g:bookmark_highlight_lines = 0
    " use 'long' converter to show actual file path
    call unite#custom_source(
          \ 'vim_bookmarks',
          \ 'converters',
          \ 'converter_vim_bookmarks_long')
  endfunction

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
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-quickrun') " {{{
  function! neobundle#hooks.on_source(bundle) abort
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

  nnoremap <Plug>(my-quickrun) <Nop>
  nmap <LocalLeader>r <Plug>(my-quickrun)
  nmap <Plug>(my-quickrun) <Plug>(quickrun)

  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-qfreplace') " {{{
  " use 'r' to call Qfreplace in QuickFix
  autocmd MyAutoCmd FileType qf nnoremap <buffer><silent> r
        \ :<C-u>Qfreplace<CR>

  call neobundle#untap()
endif " }}}

if neobundle#tap('switch.vim') " {{{
  nmap \ :<C-u>Switch<CR>

  call neobundle#untap()
endif " }}}

if neobundle#tap('linediff.vim') " {{{
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-swap') " {{{
  function! neobundle#hooks.on_source(bundle) abort
    let g:swap_enable_default_keymaps = 0
  endfunction

  nnoremap <Plug>(my-swap) <Nop>
  vnoremap <Plug>(my-swap) <Nop>
  nmap ~ <Plug>(my-swap)
  vmap ~ <Plug>(my-swap)
  vmap <Plug>(my-swap)~  <Plug>SwapSwapOperands
  vmap <Plug>(my-swap)-  <Plug>SwapSwapPivotOperands
  nmap <Plug>(my-swap)~  <Plug>SwapSwapWithR_WORD
  nmap <Plug>(my-swap)-  <Plug>SwapSwapWithL_WORD

  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-choosewin') " {{{
  nmap <C-w><C-w> <Plug>(choosewin)
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-findent') " {{{
  augroup findent
    autocmd!
    autocmd FileType json,javascript    Findent --no-warnings
    autocmd FileType css,scss,sass,less Findent --no-warnings
    autocmd FileType xml,html           Findent --no-warnings
  augroup END
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-trip') " {{{
  nmap <C-a> <Plug>(trip-increment)
  nmap <C-x> <Plug>(trip-decrement)
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-altr') " {{{
  nmap <F2> <Plug>(altr-forward)
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-foldround') " {{{
  function! neobundle#hooks.on_source(bundle) abort
    call foldround#register('\.vim$', [
          \ 'syntax', 'manual'
          \])
    call foldround#register('\.vim/.*\.vim$', [
          \ 'syntax', 'manual', 'marker',
          \])
    call foldround#register('[./]g\?vimrc$', [
          \ 'syntax', 'manual', 'marker',
          \])
  endfunction
  nmap <C-f>f     <Plug>(foldround-forward)
  nmap <C-f><C-f> <Plug>(foldround-forward)
  nmap <C-f>b     <Plug>(foldround-backward)
  nmap <C-f><C-b> <Plug>(foldround-backward)
  call neobundle#untap()
endif " }}}

if neobundle#tap('FastFold') " {{{
  call neobundle#untap()
endif " }}}


" }}}

" completion {{{

if neobundle#tap('neocomplete.vim') && has('lua') " {{{
  function! neobundle#hooks.on_source(bundle) abort
    let g:neocomplete#enable_at_startup = 1
    let g:neocomplete#enable_smart_case = 1
    let g:neocomplete#enable_fuzzy_completion = 0
    let g:neocomplete#force_omni_input_patterns = extend(
          \ get(g:, 'neocomplete#force_omni_input_patterns', {}), {
          \   'python': '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*',
          \})
    let g:neocomplete#disable_auto_complete = 1
  endfunction

  inoremap <silent><expr><C-x><C-x> neocomplete#start_manual_complete()
  inoremap <expr><CR> (pumvisible() ? "\<C-y>" : "") . "\<CR>"

  call neobundle#untap()
endif " }}}

if neobundle#tap('deoplete.nvim') && has('nvim') " {{{
  function! neobundle#hooks.on_source(bundle) abort
    let g:deoplete#enable_at_startup = 1
    let g:deoplete#enable_smart_case = 1
    let g:deoplete#enable_fuzzy_completion = 0
    let g:deoplete#force_omni_input_patterns = extend(
          \ get(g:, 'deoplete#force_omni_input_patterns', {}), {
          \   'python': '\v%([^. \t].|^\s*@|^\s*from\s.+import |^\s*from |^\s*import )\w*',
          \})
    let g:deoplete#disable_auto_complete = 1
  endfunction

  inoremap <silent><expr><C-x><C-x> deoplete#mappings#manual_complete()
  inoremap <expr><CR> (pumvisible() ? "\<C-y>" : "") . "\<CR>"

  call neobundle#untap()
endif " }}}

if neobundle#tap('neosnippet.vim') " {{{
  function! neobundle#hooks.on_post_source(bundle) abort
    let g:neosnippet#snippets_directory = rook#normpath('snippets')
    let g:neosnippet#enable_snipmate_compatibility = 1

    " for snippet complete marker
    if has('conceal')
      set conceallevel=2 concealcursor=niv
    endif
  endfunction

  " Plugin key-mappings.
  if has('lua') && neobundle#is_installed('neocomplete.vim')
    imap <expr><C-g> pumvisible()
          \ ? "\<Plug>(neosnippet_expand_or_jump)"
          \ : neosnippet#expandable_or_jumpable()
          \   ? "\<Plug>(neosnippet_expand_or_jump)"
          \   : neocomplete#start_manual_complete('neosnippet')
  else
    imap <expr><C-g> pumvisible()
          \ ? "\<Plug>(neosnippet_expand_or_jump)"
          \ : neosnippet#expandable_or_jumpable()
          \   ? "\<Plug>(neosnippet_expand_or_jump)"
          \   : deoplete#custom#manual_complete('neosnippet')
  endif
  smap <C-g> <Plug>(neosnippet_expand_or_jump)
  xmap <C-g> <Plug>(neosnippet_expand_target)

  call neobundle#untap()
endif " }}}

if neobundle#tap('echodoc.vim') " {{{
  function! neobundle#hooks.on_source(bundle) abort
    set cmdheight=2
    set completeopt+=menuone
    "set completeopt-=preview
    let g:echodoc_enable_at_startup=1
  endfunction

  call neobundle#untap()
endif " }}}

" }}}

" statusline {{{

if neobundle#tap('lightline.vim') " {{{
  let neobundle#hooks.on_source =
        \ '~/.vim/rc/plugin/lightline.vim'
  function! neobundle#hooks.on_post_source(bundle) abort
    call lightline#update()
  endfunction

  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-watchdogs') " {{{
  function! neobundle#hooks.on_source(bundle) abort
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
  endfunction

  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-qfstatusline') " {{{
  function! neobundle#hooks.on_source(bundle) abort
    let g:Qfstatusline#UpdateCmd = function('lightline#update')
  endfunction
  call neobundle#untap()
endif " }}}

" }}}

" textobj {{{

if neobundle#tap('vim-textobj-multiblock') " {{{
  omap ab <Plug>(textobj-multiblock-a)
  omap ib <Plug>(textobj-multiblock-i)
  xmap ab <Plug>(textobj-multiblock-a)
  xmap ib <Plug>(textobj-multiblock-i)
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-textobj-python') && executable('python') " {{{
  function! neobundle#hooks.on_source(bundle) abort
    function! s:textobj_python_settings() abort
      xmap <buffer> aF <Plug>(textobj-python-function-a)
      omap <buffer> iF <Plug>(textobj-python-function-i)
      xmap <buffer> aC <Plug>(textobj-python-class-a)
      omap <buffer> iC <Plug>(textobj-python-class-i)
    endfunction
    autocmd MyAutoCmd FileType python call s:textobj_python_settings()
  endfunction
  call neobundle#untap()
endif " }}}

" }}}

" operator {{{

if neobundle#tap('vim-operator-replace') " {{{
  map <Plug>(my-operator)r <Plug>(operator-replace)
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-operator-openbrowser') " {{{
  map <Plug>(my-operator)x <Plug>(operator-openbrowser)
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-operator-trailingspace-killer') " {{{
  map <Plug>(my-operator)k <Plug>(operator-trailingspace-killer)
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-operator-surround') " {{{
  function! neobundle#hooks.on_source(bundle) abort
    " add ```...``` surround when filetype is markdown
    let g:operator#surround#blocks = {
        \ 'markdown' : [
        \   {
        \     'block' : ['```\n', '\n```'],
        \     'motionwise' : ['line'],
        \     'keys' : ['`']
        \   },
        \ ]}
  endfunction

  map <Plug>(my-operator)sa <Plug>(operator-surround-append)
  map <Plug>(my-operator)sd <Plug>(operator-surround-delete)
  map <Plug>(my-operator)sr <Plug>(operator-surround-replace)

  nmap <Plug>(my-operator)sdd
        \ <Plug>(operator-surround-delete)<Plug>(textobj-multiblock-a)
  nmap <Plug>(my-operator)srr
        \ <Plug>(operator-surround-replace)<Plug>(textobj-multiblock-a)
  vmap <Plug>(my-operator)sdd
        \ <Plug>(operator-surround-delete)<Plug>(textobj-multiblock-a)
  vmap <Plug>(my-operator)srr
        \ <Plug>(operator-surround-replace)<Plug>(textobj-multiblock-a)
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-operator-breakline') " {{{
  map <Plug>(my-operator)b <Plug>(operator-breakline-manual)
  map <Plug>(my-operator)B <Plug>(operator-breakline-textwidth)
  call neobundle#untap()
endif " }}}

if neobundle#tap('concealedyank.vim') " {{{
  xmap Y <Plug>(operator-concealedyank)
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-operator-flashy') " {{{
  map y <Plug>(operator-flashy)
  map Y <Plug>(operator-flashy)$
  call neobundle#untap()
endif " }}}

" }}}

" interfaces {{{

if neobundle#tap('ctrlp.vim') " {{{
  function! neobundle#hooks.on_source(bundle) abort
    let g:ctrlp_map = '<Nop>'
    let g:ctrlp_cmd = 'CtrlP'
    " Guess VCS root directory as well
    let g:ctrlp_working_path_mode = 'ra'
  endfunction

endif " }}}

if neobundle#tap('unite.vim') " {{{
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
  if neobundle#is_installed('unite-quickfix')
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
  endif

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
  if neobundle#is_installed('vim-unite-giti')
    nnoremap <silent> <Plug>(my-unite-git)i
          \ :<C-u>Unite giti/branch_recent<CR>
    nnoremap <silent> <Plug>(my-unite-git)b
          \ :<C-u>Unite giti/branch_recent giti/branch_all<CR>
    nnoremap <silent> <Plug>(my-unite-git)r
          \ :<C-u>Unite giti/remote<CR>
  endif
  if neobundle#is_installed('vim-gista')
    nnoremap <silent> <Plug>(my-unite-git)t
          \ :<C-u>Unite gista:lambdalisue<CR>
  endif

  " unite-ref
  nnoremap <Plug>(my-unite-ref) <Nop>
  nmap <Plug>(my-unite)r <Plug>(my-unite-ref)
  if neobundle#is_installed('vim-ref')
    nnoremap <silent> <Plug>(my-unite-ref)r
                \ :<C-u>call <SID>unite_smart_ref()<CR>
    nnoremap <silent> <Plug>(my-unite-ref)p
                \ :<C-u>Unite ref/pydoc<CR>
    nnoremap <silent> <Plug>(my-unite-ref)l
                \ :<C-u>Unite perldoc<CR>
    nnoremap <silent> <Plug>(my-unite-ref)m
                \ :<C-u>Unite ref/man<CR>
    if neobundle#is_installed('ref-sources.vim')
      nnoremap <silent> <Plug>(my-unite-ref)j
                  \ :<C-u>Unite ref/javascript<CR>
      nnoremap <silent> <Plug>(my-unite-ref)q
                  \ :<C-u>Unite ref/jquery<CR>
      nnoremap <silent> <Plug>(my-unite-ref)k
                  \ :<C-u>Unite ref/kotobank<CR>
      nnoremap <silent> <Plug>(my-unite-ref)w
                  \ :<C-u>Unite ref/wikipedia<CR>
    endif
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
  endif

  " unite-linephrase
  if neobundle#is_installed('unite-linephrase')
    nnoremap <silent> <Plug>(my-unite)p
          \ :<C-u>Unite linephrase
          \ -buffer-name=search<CR>
  endif

  " unite-outline
  if neobundle#is_installed('unite-outline')
    " Use outline like explorer
    nnoremap <silent> <Leader>o
          \ :<C-u>Unite outline
          \ -no-quit -keep-focus -no-start-insert
          \ -vertical -direction=botright -winwidth=30<CR>
  endif

  " vim-bookmarks
  if neobundle#is_installed('vim-bookmarks')
    nnoremap <silent> <Plug>(my-unite)mm
          \ :<C-u>Unite vim_bookmarks
          \ -buffer-name=search<CR>
  endif

  let neobundle#hooks.on_source = rook#normpath('rc/plugin/unite.vim')
  call neobundle#untap()
endif " }}}

if neobundle#tap('vimshell.vim') " {{{
  let neobundle#hooks.on_source = rook#normpath('rc/plugin/vimshell.vim')
  function! neobundle#hooks.on_post_source(bundle)
    highlight! vimshellError gui=NONE cterm=NONE guifg='#cc6666' ctermfg=9
  endfunction

  nnoremap <Plug>(my-vimshell) <Nop>
  nmap s <Plug>(my-vimshell)
  nnoremap <silent> <Plug>(my-vimshell)s :<C-u>VimShell<CR>
  nnoremap <silent> <Plug>(my-vimshell)v :<C-u>VimShell -split -split-command=vsplit<CR>
  nnoremap <silent> <Plug>(my-vimshell)h :<C-u>VimShell -split -split-command=split<CR>
  nnoremap <silent> <Plug>(my-vimshell)t :<C-u>VimShellTab<CR>

  call neobundle#untap()
endif " }}}

if neobundle#tap('vimfiler.vim') " {{{
  nnoremap <Plug>(my-vimfiler) <Nop>
  nmap <Leader>e <Plug>(my-vimfiler)
  nnoremap <silent> <Plug>(my-vimfiler)e :<C-u>VimFilerExplorer<CR>
  nnoremap <silent> <Plug>(my-vimfiler)E :<C-u>VimFiler<CR>
  let neobundle#hooks.on_source = rook#normpath('rc/plugin/vimfiler.vim')
  call neobundle#untap()
endif " }}}

if neobundle#tap('undotree') " {{{
  nnoremap <Plug>(my-undotree) <Nop>
  nmap <Leader>u <Plug>(my-undotree)
  nnoremap <silent> <Plug>(my-undotree) :<C-u>UndotreeToggle<CR>

  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-ref') " {{{
  function! neobundle#hooks.on_source(bundle) abort
    let g:ref_open = 'vsplit'
    function! s:ref_configure() abort
      nmap <buffer><silent> <C-p> <Plug>(ref-back)
      nmap <buffer><silent> <C-n> <Plug>(ref-forward)
    endfunction
    autocmd MyAutoCmd FileType ref call s:ref_configure()
  endfunction
  call neobundle#untap()
endif " }}}

if neobundle#tap('ref-sources.vim') " {{{
  function! neobundle#hooks.on_source(bundle) abort
    let g:ref_jquery_doc_path     = rook#normpath('bundle/jqapi')
    let g:ref_javascript_doc_path = rook#normpath('bundle/jsref/htdocs')
    let g:ref_auto_resize = 1
    let g:ref_wikipedia_lang = ['ja', 'en']
  endfunction

  call neobundle#untap()
endif " }}}

if neobundle#tap('tagbar') " {{{
  nnoremap <Plug>(my-tagbar) <Nop>
  nmap <Leader>t <Plug>(my-tagbar)
  nnoremap <silent> <Plug>(my-tagbar) :<C-u>TagbarToggle<CR>
  call neobundle#untap()
endif " }}}

if neobundle#tap('memolist.vim') " {{{
  nnoremap <Plug>(my-memolist) <Nop>
  nmap <Leader>m <Plug>(my-memolist)
  nnoremap <silent> <Plug>(my-memolist)m :<C-u>MemoList<CR>
  nnoremap <silent> <Plug>(my-memolist)n :<C-u>MemoNew<CR>
  nnoremap <silent> <Plug>(my-memolist)g :<C-u>MemoGrep<CR>

  function! neobundle#hooks.on_source(bundle) abort
    let g:memolist_qfixgrep = 1
    let g:memolist_path = expand('~/Dropbox/Apps/Byword/')
    let g:memolist_unite = 1
    let g:memolist_unite_option = '-no-start-insert'
  endfunction

  call neobundle#untap()
endif " }}}

if neobundle#tap('tabular') " {{{
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
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-rengbang') " {{{
  function! neobundle#hooks.on_source(bundle) abort
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

  nnoremap <Plug>(my-rengbang) <Nop>
  vmap <C-a> <Plug>(my-rengbang)
  vnoremap <Plug>(my-rengbang)a :<C-u>'<,'>RengBang<CR>
  vnoremap <Plug>(my-rengbang)A :<C-u>'<,'>RengBangUsePrev<CR>
  vnoremap <Plug>(my-rengbang)c :<C-u>'<,'>RengBangConfirm<CR>

  map <Plug>(my-operator)rr <Plug>(operator-rengbang)
  map <Plug>(my-operator)rR <Plug>(operator-rengbang-useprev)
  call neobundle#untap()
endif " }}}

if neobundle#tap('colorizer') " {{{
  " Note:
  "   This plugin is quite heavy and it add BufEnter autocmd to visualize
  "   color thus should not be autoloaded with filetype or so on.
  function! neobundle#hooks.on_source(bundle) abort
    let g:colorizer_nomap = 1
  endfunction

  call neobundle#untap()
endif " }}}

if neobundle#tap('calendar.vim') " {{{
  function! neobundle#hooks.on_source(bundle) abort
    let g:calendar_frame = 'default'
    let g:calendar_google_calendar = 1
    let g:calendar_google_task = 1
  endfunction

  nnoremap <Plug>(my-calendar) <Nop>
  nmap <Leader>c <Plug>(my-calendar)
  nnoremap <silent> <Plug>(my-calendar)c :<C-u>Calendar<CR>
  nnoremap <silent> <Plug>(my-calendar)t :<C-u>Calendar -view=clock<CR>

  call neobundle#untap()
endif " }}}
" }}}

" unite sources {{{

if neobundle#tap('unite-linephrase') " {{{
  function! neobundle#hooks.on_source(bundle) abort
    let g:linephrase#directory = expand('~/Dropbox/Apps/Vim/linephrase')
  endfunction
  call neobundle#untap()
endif " }}}

" }}}

" version controller system {{{

if neobundle#tap('vim-gista') " {{{
  function! neobundle#hooks.on_source(bundle) abort
    let g:gista#client#default_username = 'lambdalisue'
  endfunction
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-gita') && executable('git') " {{{
  function! neobundle#hooks.on_source(bundle) abort
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

  nnoremap <Plug>(my-gita) <Nop>
  nmap <Leader>a <Plug>(my-gita)
  nnoremap <Plug>(my-gita)a :<C-u>Gita status  --ignore-submodules<CR>
  nnoremap <Plug>(my-gita)s :<C-u>Gita status<CR>
  nnoremap <Plug>(my-gita)c :<C-u>Gita commit<CR>
  nnoremap <Plug>(my-gita)d :<C-u>Gita diff    --ignore-submodules -- %<CR>
  nnoremap <Plug>(my-gita)l :<C-u>Gita diff-ls --ignore-submodules origin/HEAD...<CR>

  call neobundle#untap()
endif " }}}

if neobundle#tap('agit.vim') && executable('git') " {{{
  function! neobundle#hooks.on_source(bundle) abort
    " add extra key-mappings
    function! s:my_agit_setting() abort
      nmap <buffer> ch <Plug>(agit-git-cherry-pick)
      nmap <buffer> Rv <Plug>(agit-git-revert)
    endfunction
    autocmd MyAutoCmd FileType agit call s:my_agit_setting()
  endfunction

  call neobundle#untap()
endif " }}}

" }}}

" syntax {{{

if neobundle#tap('typescript-vim') " {{{
  function! neobundle#hooks.on_source(bundle) abort
    let g:typescript_indent_disable = 1
    let g:typescript_compiler_options = '-sourcemap'
  endfunction
  call neobundle#untap()
endif " }}}

" }}}

" filetype specific {{{
if neobundle#tap('LaTeX-Box') && executable('latexmk') " {{{
  function! neobundle#hooks.on_source(bundle) abort
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
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-autopep8') && executable('autopep8') " {{{
  function! neobundle#hooks.on_source(bundle) abort
    let g:autopep8_disable_show_diff = 1
  endfunction
  call neobundle#untap()
endif " }}}

if neobundle#tap('jedi-vim') && executable('python') " {{{
  function! neobundle#hooks.on_source(bundle) abort
    function! s:jedi_vim_configure() abort
      setl omnifunc=jedi#completions
      setl completeopt=menu,longest

      nmap <buffer> <LocalLeader>g <Plug>(jedi-goto-assignments)
      nmap <buffer> <LocalLeader>d <Plug>(jedi-goto-definitions)
      nmap <buffer> <LocalLeader>R <Plug>(jedi-rename)
      nmap <buffer> <LocalLeader>n <Plug>(jedi-usage)
      nmap <buffer> K <Plug>(jedi-show-documentation)
    endfunction
    autocmd MyAutoCmd FileType python call s:jedi_vim_configure()
  endfunction

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

  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-pyenv') && executable('pyenv') " {{{
  function! neobundle#hooks.on_source(bundle) abort
    if neobundle#is_installed('jedi') && jedi#init_python()
      function! s:jedi_auto_force_py_version() abort
        let major_version = pyenv#python#get_internal_major_version()
        call jedi#force_py_version(major_version)
      endfunction
      autocmd MyAutoCmd User vim-pyenv-activate-post   call s:jedi_auto_force_py_version()
      autocmd MyAutoCmd User vim-pyenv-deactivate-post call s:jedi_auto_force_py_version()
    endif
  endfunction
  call neobundle#untap()
endif " }}}

if neobundle#tap('tsuquyomi') && executable('tsc') " {{{
  function! neobundle#hooks.on_source(bundle) abort
    function! s:tsuquyomi_configure() abort
      nmap <buffer> <LocalLeader>d <Plug>(TsuquyomiDefinition)
      nmap <buffer> <LocalLeader>b <Plug>(TsuquyomiGoBack)
      nmap <buffer> <LocalLeader>r <Plug>(TsuquyomiReferences)
      nmap <buffer> <LocalLeader>R <Plug>(TsuquyomiRenameSymbolC)
      if exists('&ballooneval')
        setl ballooneval
        setl balloonexpr=tsuquyomi#balloonexpr()
      endif
    endfunction
    autocmd MyAutoCmd FileType typescript call s:tsuquyomi_configure()
  endfunction
  call neobundle#untap()
endif " }}}

" }}}
