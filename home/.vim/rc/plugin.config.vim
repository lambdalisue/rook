scriptencoding utf-8
noremap <Plug>(my-operator) <Nop>
map - <Plug>(my-operator)

function! s:is_git_available() abort "{{{
  if !executable('git')
    return 0
  endif
  if neobundle#is_sourced('vim-gita')
    return gita#is_enabled()
  endif
  call vimproc#system('git rev-parse')
  return (vimproc#get_last_status() == 0) ? 1 : 0
endfunction "}}}

if neobundle#tap('vimproc.vim') " {{{
  call neobundle#config({
        \ 'build_commands': 'make',
        \ 'build': {
        \   'windows' : 'tools\\update-dll-mingw',
        \   'cygwin'  : 'make -f make_cygwin.mak',
        \   'mac'     : 'make -f make_mac.mak',
        \   'linux'   : 'make',
        \   'unix'    : 'gmake',
        \ }})
  call neobundle#untap()
endif " }}}

" fundementals {{{

if neobundle#tap('sudo.vim') " {{{
  cabbr w!! :w sudo:%
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-hier') " {{{
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

if neobundle#tap('vim-unified-diff') " {{{
  call neobundle#config({
        \ 'external_commands': 'git',
        \ })
  function! neobundle#hooks.on_source(bundle) abort
    let unified_diff#arguments = [
          \   'diff',
          \   '--no-index',
          \   '--no-color',
          \   '--no-ext-diff',
          \   '--unified=0',
          \   '--histogram',
          \ ]
    if executable('git')
      set diffexpr=unified_diff#diffexpr()
    endif
  endfunction
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-repeat') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'mappings': '<Plug>(repeat-',
        \ }})

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
  call neobundle#config({
        \ 'depends': 'kana/vim-operator-user',
        \ 'autoload': {
        \   'mappings': [
        \     '<Plug>(quickhl-manual',
        \     '<Plug>(operator-quickhl-manual',
        \   ],
        \ }})

  nnoremap <Plug>(my-quickhl) <Nop>
  vnoremap <Plug>(my-quickhl) <Nop>
  xnoremap <Plug>(my-quickhl) <Nop>
  nmap H <Plug>(my-quickhl)
  vmap H <Plug>(my-quickhl)
  xmap H <Plug>(my-quickhl)

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
  call neobundle#config({
        \ 'autoload': {
        \   'mappings': '<Plug>(openbrowser-',
        \ }})

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
  call neobundle#config({
        \ 'autoload': {
        \   'mappings': '<Plug>(fullscreen-',
        \ }})
  nmap <C-CR> <Plug>(fullscreen-toggle)
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-over') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'commands': [
        \     'OverCommandLine',
        \     'OverCommandLineNoremap',
        \   ],
        \ }})

  " Automatically source it when the command window is opened.
  function! s:source_vim_over() abort
    call neobundle#source('vim-over')
    " do plugin-over autocmd
    doautoall plugin-over CmdwinEnter
    " remove autocmd
    augroup MyAutoCmdSourceVimOver
      autocmd!
    augroup END
  endfunction
  augroup MyAutoCmdSourceVimOver
    autocmd!
    autocmd CmdwinEnter * call s:source_vim_over()
  augroup END

  " Use vim-over instead of builtin substitution
  " http://leafcage.hateblo.jp/entry/2013/11/23/212838
  cnoreabb <silent><expr>s getcmdtype()==':' && getcmdline()=~'^s' ?
        \ 'OverCommandLine<CR><C-u>%s/<C-r>=get([], getchar(0), '')<CR>' : 's'

  function! neobundle#hooks.on_source(bundle) abort
    let g:over_enable_auto_nohlsearch = 1
    let g:over_enable_cmd_window = 1
    let g:over#command_line#search#enable_incsearch = 1
  endfunction
  call neobundle#untap()
endif " }}}

if neobundle#tap('clever-f.vim') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'mappings': '<Plug>(clever-f-',
        \ }})
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
  call neobundle#config({
        \ 'autoload': {
        \   'mappings': '<Plug>(asterisk-',
        \   'on_source': [ 'incsearch.vim' ],
        \ }})
  call neobundle#untap()
endif " }}}

if neobundle#tap('incsearch.vim') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'mappings': '<Plug>(incsearch-',
        \ }})

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
  call neobundle#config({
        \ 'autoload': {
        \   'mappings': '<Plug>(yankround-',
        \ }})
  function! neobundle#hooks.on_source(bundle) abort
    let g:yankround_use_region_hl = 0
  endfunction

  nmap p     <Plug>(yankround-p)
  nmap P     <Plug>(yankround-P)
  nmap gp    <Plug>(yankround-gp)
  nmap gP    <Plug>(yankround-gP)
  nmap <C-p> <Plug>(yankround-prev)
  nmap <C-n> <Plug>(yankround-next)

  call neobundle#untap()
endif " }}}

if neobundle#tap('concealedyank.vim') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'mappings': '<Plug>(operator-concealedyank',
        \ }})

  xmap Y <Plug>(operator-concealedyank)

  call neobundle#untap()
endif " }}}

if neobundle#tap('capture.vim') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'commands': [
        \     'Capture',
        \   ],
        \ }})
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-bookmarks') " {{{
  call neobundle#config({
        \ 'depends': ['Shougo/unite.vim'],
        \ 'augroup': 'bm_vim_enter',
        \ 'autoload': {
        \   'mappings': '<Plug>Bookmark',
        \   'unite_sources': 'vim_bookmarks',
        \ }})
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
  call neobundle#config({
        \ 'autoload': {
        \   'mappings': '<Plug>(quickrun',
        \ }})

  function! neobundle#hooks.on_source(bundle) abort
    let g:quickrun_config = get(g:, 'quickrun_config', {})
    let g:quickrun_config['_'] = {
          \ 'runner' : 'vimproc',
          \ 'outputter/buffer/split': ':botright 8sp',
          \ 'outputter/buffer/close_on_empty': 1,
          \ 'hook/time/enable': 1,
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
  call neobundle#config({
        \ 'autoload': {
        \   'on_source': [
        \     'unite.vim',
        \     'vimfiler.vim',
        \   ],
        \   'commands': [
        \     'Qfreplace',
        \   ],
        \ }})

  " use 'r' to call Qfreplace in QuickFix
  autocmd MyAutoCmd FileType qf nnoremap <buffer><silent> r
        \ :<C-u>Qfreplace<CR>

  call neobundle#untap()
endif " }}}

if neobundle#tap('switch.vim') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'commands': [
        \     'Switch',
        \   ],
        \ }})

  nmap \ :<C-u>Switch<CR>

  call neobundle#untap()
endif " }}}

if neobundle#tap('linediff.vim') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'commands': [
        \     'Linediff',
        \     'LinediffReset',
        \   ],
        \ }})

  vnoremap <Plug>(my-linediff) <Nop>
  nnoremap <Plug>(my-linediff) <Nop>
  vmap <S-l> <Plug>(my-linediff)
  nmap <S-l> <Plug>(my-linediff)
  nmap <Plug>(my-linediff)d v$:<C-u>Linediff<CR>
  nmap <Plug>(my-linediff)r :<C-u>LinediffReset<CR>
  vmap <Plug>(my-linediff)d :<C-u>'<,'>Linediff<CR>
  vmap <Plug>(my-linediff)r :<C-u>LinediffReset<CR>

  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-swap') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'mappings': '<Plug>SwapSwap',
        \ }})

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

if neobundle#tap('vim-pager') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'commands': 'PAGER',
        \ }})
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-manpager') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'commands': ['MANPAGER', 'Man'],
        \ }})
  call neobundle#untap()
endif " }}}

" }}}

" completion " {{{

if neobundle#tap('deoplete.nvim') && has('nvim') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'insert': 1,
        \ }})
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

  "inoremap <expr><C-x><C-x> deoplete#start_manual_complete()
  inoremap <expr><C-g> deoplete#undo_completion()
  inoremap <expr><C-l> deoplete#complete_common_string()

  call neobundle#untap()
endif " }}}

if neobundle#tap('neocomplete.vim') && !has('nvim') " {{{
  call neobundle#config({
        \ 'disabled': !has('lua'),
        \ 'autoload': {
        \   'insert': 1,
        \ }})
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

  inoremap <expr><C-x><C-x> neocomplete#start_manual_complete()
  inoremap <expr><C-g> neocomplete#undo_completion()
  inoremap <expr><C-l> neocomplete#complete_common_string()

  call neobundle#untap()
endif " }}}

if neobundle#tap('neco-syntax') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'on_source': has('nvim') ? 'deocomplete.vim' : 'neocomplete.vim',
        \ }})

  call neobundle#untap()
endif " }}}

if neobundle#tap('neco-vim') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'on_source': has('nvim') ? 'deocomplete.vim' : 'neocomplete.vim',
        \ }})

  call neobundle#untap()
endif " }}}

if neobundle#tap('neoinclude.vim') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'on_source': has('nvim') ? 'deocomplete.vim' : 'neocomplete.vim',
        \ }})

  call neobundle#untap()
endif " }}}

if neobundle#tap('neco-look') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'on_source': has('nvim') ? 'deocomplete.vim' : 'neocomplete.vim',
        \ }})

  call neobundle#untap()
endif " }}}

if neobundle#tap('neco-ghc') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'on_source': has('nvim') ? 'deocomplete.vim' : 'neocomplete.vim',
        \ }})

  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-neco-calc') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'on_source': has('nvim') ? 'deocomplete.vim' : 'neocomplete.vim',
        \ }})

  call neobundle#untap()
endif " }}}

if neobundle#tap('neosnippet.vim') " {{{
  call neobundle#config({
        \ 'depends': 'Shougo/neosnippet-snippets',
        \ 'autoload': {
        \   'mappings': '<Plug>(neosnippet_expand',
        \   'commands': [
        \     'NeoSnippetMakeCache',
        \     'NeoSnippetEdit',
        \     'NeoSnippetSource',
        \     'NeoSnippetClearMarkers',
        \   ],
        \ }})

  function! neobundle#hooks.on_post_source(bundle) abort
    let g:neosnippet#snippets_directory = $MYVIMRUNTIME. '/snippets'
    let g:neosnippet#enable_snipmate_compatibility = 1

    " for snippet complete marker
    if has('conceal')
      set conceallevel=2 concealcursor=niv
    endif
  endfunction

  " Plugin key-mappings.
  imap <C-k> <Plug>(neosnippet_expand_or_jump)
  smap <C-k> <Plug>(neosnippet_expand_or_jump)
  xmap <C-k> <Plug>(neosnippet_expand_target)

  call neobundle#untap()
endif " }}}

if neobundle#tap('echodoc.vim') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'insert': 1,
        \ }})

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
  call MyLoadSource($MYVIMRUNTIME . '/rc/plugin/lightline.vim')

  function! neobundle#hooks.on_source(bundle) " {{{
    set noshowmode
  endfunction " }}}

  function! neobundle#hooks.on_post_source(bundle) abort
    call lightline#update()
  endfunction

  call neobundle#untap()
endif " }}}

if neobundle#tap('lightline-hybrid.vim') " {{{
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
  " Note:
  " https://github.com/Shougo/neobundle.vim/issues/446
  "call neobundle#config({
  "      \ 'depends': 'osyo-manga/shabadou.vim',
  "      \})
  function! neobundle#hooks.on_source(bundle) abort
    let g:Qfstatusline#UpdateCmd = function('lightline#update')
  endfunction
  call neobundle#untap()
endif " }}}

" }}}

" textobj {{{

if neobundle#tap('vim-textobj-user') " {{{
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-textobj-entire') " {{{
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-textobj-line') " {{{
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-textobj-syntax') " {{{
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-textobj-indent') " {{{
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-textobj-datetime') " {{{
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-textobj-comment') " {{{
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-textobj-space') " {{{
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-textobj-fold') " {{{
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-textobj-underscore') " {{{
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-textobj-dash') " {{{
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-textobj-url') " {{{
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-textobj-parameter') " {{{
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-textobj-multiblock') " {{{

  omap ab <Plug>(textobj-multiblock-a)
  omap ib <Plug>(textobj-multiblock-i)
  xmap ab <Plug>(textobj-multiblock-a)
  xmap ib <Plug>(textobj-multiblock-i)

  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-textobj-word-column') " {{{
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-textobj-python') " {{{
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
if neobundle#tap('vim-operator-user') " {{{
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-operator-replace') " {{{
  call neobundle#config({
        \ 'depends': 'kana/vim-operator-user',
        \ 'autoload': {
        \   'mappings': '<Plug>(operator-replace',
        \ }})

  map <silent> <Plug>(my-operator)r <Plug>(operator-replace)

  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-operator-openbrowser') " {{{
  call neobundle#config({
        \ 'depends': 'kana/vim-operator-user',
        \ 'autoload': {
        \   'mappings': '<Plug>(operator-openbrowser',
        \ }})
  map <silent> <Plug>(my-operator)x <Plug>(operator-openbrowser)
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-operator-trailingspace-killer') " {{{
  call neobundle#config({
        \ 'depends': 'kana/vim-operator-user',
        \ 'autoload': {
        \   'mappings': '<Plug>(operator-trailingspace-killer',
        \ }})
  map <silent> <Plug>(my-operator)k <Plug>(operator-trailingspace-killer)
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-operator-surround') " {{{
  call neobundle#config({
        \ 'depends': 'kana/vim-operator-user',
        \ 'autoload': {
        \   'mappings': '<Plug>(operator-surround',
        \ }})

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

  map <silent> <Plug>(my-operator)sa <Plug>(operator-surround-append)
  map <silent> <Plug>(my-operator)sd <Plug>(operator-surround-delete)
  map <silent> <Plug>(my-operator)sr <Plug>(operator-surround-replace)

  nmap <silent> <Plug>(my-operator)sdd
        \ <Plug>(operator-surround-delete)<Plug>(textobj-multiblock-a)
  nmap <silent> <Plug>(my-operator)srr
        \ <Plug>(operator-surround-replace)<Plug>(textobj-multiblock-a)
  vmap <silent> <Plug>(my-operator)sdd
        \ <Plug>(operator-surround-delete)<Plug>(textobj-multiblock-a)
  vmap <silent> <Plug>(my-operator)srr
        \ <Plug>(operator-surround-replace)<Plug>(textobj-multiblock-a)
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-operator-breakline') " {{{
  call neobundle#config({
        \ 'depends': 'kana/vim-operator-user',
        \ 'autoload': {
        \   'mappings': '<Plug>(operator-breakline',
        \ }})

  map <silent> Gq <Plug>(operator-breakline-manual)
  map <silent> GQ <Plug>(operator-breakline-textwidth)
  call neobundle#untap()
endif " }}}

" }}}

" interfaces {{{
"
if neobundle#tap('unite.vim') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'commands': [
        \     'Unite',
        \   ],
        \ }})
  call MyLoadSource($MYVIMRUNTIME . '/rc/plugin/unite.vim')
  call neobundle#untap()
endif " }}}

if neobundle#tap('vimshell.vim') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'commands': [
        \     'VimShell',
        \     'VimShellPop',
        \     'VimShellInteractive',
        \     'VimShellSendString',
        \   ],
        \ }})
  call MyLoadSource($MYVIMRUNTIME . '/rc/plugin/vimshell.vim')
  call neobundle#untap()
endif " }}}

if neobundle#tap('vimfiler.vim') " {{{
  call neobundle#config({
        \ 'depends': 'Shougo/unite.vim',
        \ 'autoload': {
        \   'commands': [
        \     'VimFiler',
        \     'VimFilerExplorer',
        \   ],
        \   'explorer': 1,
        \ }})
  call MyLoadSource($MYVIMRUNTIME . '/rc/plugin/vimfiler.vim')
  call neobundle#untap()
endif " }}}

if neobundle#tap('undotree.vim') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'commands': [
        \     'UndotreeToggle',
        \   ],
        \ }})

  nnoremap <Plug>(my-undotree) <Nop>
  nmap <Leader>u <Plug>(my-undotree)
  nnoremap <silent> <Plug>(my-undotree) :<C-u>UndotreeToggle<CR>

  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-ref') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'commands': [
        \     'Ref',
        \   ],
        \ }})

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
  call neobundle#config({
        \ 'autoload': {
        \   'on_source': 'vim-ref',
        \ }})

  function! neobundle#hooks.on_source(bundle) abort
    let g:ref_jquery_doc_path     = $MYVIMRUNTIME . '/bundle/jqapi'
    let g:ref_javascript_doc_path = $MYVIMRUNTIME . '/bundle/jsref/htdocs'
    let g:ref_auto_resize = 1
    let g:ref_wikipedia_lang = ['ja', 'en']
  endfunction

  call neobundle#untap()
endif " }}}

if neobundle#tap('tagbar') " {{{
  call neobundle#config({
        \ 'augroup': 'TagbarAutoCmds',
        \ 'autoload': {
        \   'commands': [
        \     'Tagbar',
        \     'TagbarToggle',
        \   ],
        \ }})

  nnoremap <Plug>(my-tagbar) <Nop>
  nmap <Leader>t <Plug>(my-tagbar)
  nnoremap <silent> <Plug>(my-tagbar) :<C-u>TagbarToggle<CR>
  call neobundle#untap()
endif " }}}

if neobundle#tap('memolist.vim') " {{{
  call neobundle#config({
        \ 'depends': ['Shougo/unite.vim', 'fuenor/qfixgrep.git'],
        \ 'autoload': {
        \   'commands': [
        \     'MemoNew', 'MemoList', 'MemoGrep',
        \   ],
        \ }})

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
  call neobundle#config({
        \ 'autoload': {
        \   'commands': [
        \     'Tabularize',
        \   ],
        \ }})

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
  call neobundle#config({
        \ 'autoload': {
        \   'commands': [
        \     'RengBang',
        \     'RengBangUsePrev',
        \     'RengBangConfirm',
        \   ],
        \ }})

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
  call neobundle#config({
        \ 'autoload': {
        \   'mappings': '<Plug>Colorizer',
        \   'commands': [
        \     'ColorHighlight',
        \     'ColorClear',
        \     'ColorToggle',
        \   ],
        \ }})

  function! neobundle#hooks.on_source(bundle) abort
    let g:colorizer_nomap = 1
  endfunction

  call neobundle#untap()
endif " }}}

if neobundle#tap('calendar.vim') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'commands': [
        \     'Calendar',
        \   ],
        \ }})

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
function! s:configure_neobundle_sources(sources) abort
  for src in a:sources
    if neobundle#tap(src[0])
      call neobundle#config({
            \ 'depends': 'Shougo/unite.vim',
            \ 'autoload': {
            \   'unite_sources': src[1],
            \ }})
      call neobundle#untap()
    endif
    unlet! src
  endfor
endfunction

call s:configure_neobundle_sources([
      \ ['neomru.vim', ['file_mru', 'directory_mru', 'neomru/file', 'neomru/directory']],
      \ ['neossh.vim', 'ssh'],
      \ ['unite-help', 'help'],
      \ ['unite-outline', 'outline'],
      \ ['unite-quickfix', ['quickfix', 'location_list']],
      \ ['unite-font', 'font'],
      \ ['unite-colorscheme', 'colorscheme'],
      \ ['unite-codic.vim', 'codic'],
      \ ['unite-webcolorname', 'webcolorname'],
      \ ['unite-linephase', 'linephase'],
      \ ['unite-pull-request', 'pull_request'],
      \ ['unite-grep-vcs', ['grep/git', 'grep/hg']],
      \ ['unite-perldoc', 'perldoc'],
      \])

if neobundle#tap('unite-linephrase') " {{{
  function! neobundle#hooks.on_source(bundle) abort
    let g:linephrase#directory = expand('~/Copy/Apps/Vim/linephrase')
  endfunction

  call neobundle#untap()
endif " }}}
" }}}

" version controller system {{{

if neobundle#tap('vim-gita') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'commands': 'Gita',
        \   'mappings': '<Plug>(gita-',
        \ }})
  function! neobundle#hooks.on_source(bundle) abort
    let g:gita#features#browse#extra_translation_patterns = {
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

if neobundle#tap('agit.vim') " {{{
  call neobundle#config({
        \ 'focus': 1,
        \ 'autoload': {
        \   'on_source': 'unite.vim',
        \   'commands': [
        \     'Agit',
        \     'AgitFile',
        \   ],
        \ }})

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

if neobundle#tap('vim-unite-giti') " {{{
  call neobundle#config({
        \ 'focus': 1,
        \ 'depends': 'Shougo/unite.vim',
        \ 'autoload': {
        \   'unite_sources': [
        \     'giti',
        \     'giti/branch',
        \     'giti/config',
        \     'giti/log',
        \     'giti/remote',
        \     'giti/status',
        \     'giti/pull_request/base',
        \     'giti/pull_request/head',
        \   ],
        \ }})
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-gista') " {{{
  call neobundle#config({
        \ 'focus': 1,
        \ 'depends': [
        \   'Shougo/unite.vim',
        \   'tyru/open-browser.vim',
        \ ],
        \ 'autoload': {
        \   'commands': 'Gista',
        \   'mappings': '<Plug>(gista-',
        \   'unite_sources': 'gista',
        \ }})
  call neobundle#untap()
endif " }}}

" }}}

" syntax {{{

if neobundle#tap('vim-css3-syntax') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'filetypes': ['css', 'sass', 'scss', 'less', 'html', 'djangohtml'],
        \ }})
  call neobundle#untap()
endif " }}}

if neobundle#tap('html5.vim') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'filetypes': ['html', 'djangohtml'],
        \ }})
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-less') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'filetypes': ['less'],
        \ }})
  call neobundle#untap()
endif " }}}

if neobundle#tap('scss-syntax.vim') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'filetypes': ['sass', 'scss'],
        \ }})
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-coffee-script') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'filetypes': ['coffee', 'coffeescript'],
        \ }})
  call neobundle#untap()
endif " }}}

if neobundle#tap('jQuery') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'filetypes': [
        \     'coffee', 'coffeescript', 'javascript',
        \     'html', 'djangohtml',
        \   ],
        \ }})
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-javascript-syntax') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'filetypes': [
        \     'javascript',
        \   ],
        \ }})
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-js-indent') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'filetypes': [
        \     'javascript',
        \   ],
        \ }})
  call neobundle#untap()
endif " }}}

if neobundle#tap('typescript-vim') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'filetypes': [
        \     'typescript',
        \   ],
        \ }})
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-ft-help_fold') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'filetypes': [
        \     'help',
        \   ],
        \ }})
  call neobundle#untap()
endif " }}}

if neobundle#tap('applescript.vim') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'filetypes': [
        \     'applescript',
        \   ],
        \ }})
  call neobundle#untap()
endif " }}}

" }}}

" filetype specific {{{
if neobundle#tap('LaTeX-Box') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'commands': [
        \     'Latexmk',
        \     'LatexmkClean',
        \     'LatexmkStatus',
        \     'LatexmkStop',
        \     'LatexmkErrors',
        \     'LatexView',
        \     'LatexTOC',
        \     'LatexTOCToggle',
        \     'LatexLabels',
        \   ],
        \   'filetypes': ['tex', 'plaintex',]
        \ }})

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

if neobundle#tap('vim-autopep8') " {{{
  call neobundle#config({
        \ 'external_commands': 'autopep8',
        \ 'autoload': {
        \   'filetypes': ['python', 'python3', 'djangohtml'],
        \ },
        \ 'build_commands': 'pip',
        \ 'build': {
        \   'mac'     : 'pip install autopep8',
        \   'unix'    : 'pip install autopep8',
        \ }
        \})
  function! neobundle#hooks.on_source(bundle) abort
    let g:autopep8_disable_show_diff = 1
  endfunction
  call neobundle#untap()
endif " }}}

if neobundle#tap('indentpython.vim') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'filetypes': ['python', 'python3', 'djangohtml'],
        \ }})
  call neobundle#untap()
endif " }}}

if neobundle#tap('python_match.vim') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'filetypes': ['python', 'python3', 'djangohtml'],
        \ }})
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-django-support') " {{{
  " call neobundle#config({
  "       \ 'autoload': {
  "       \   'filetypes': ['python', 'python3', 'djangohtml'],
  "       \ }})
  call neobundle#untap()
endif " }}}

if neobundle#tap('jedi-vim') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'on_source': 'vim-pyenv',
        \ },
        \ 'build_commands': 'git',
        \ 'build': {
        \   '*'     : 'git submodule update --init',
        \ },
        \})

  function! neobundle#hooks.on_source(bundle) abort
    let g:jedi#auto_initialization = 0
    let g:jedi#auto_vim_configuration = 0
    let g:jedi#popup_on_dot = 0
    let g:jedi#popup_select_first = 0
    let g:jedi#auto_close_doc = 0
    let g:jedi#show_call_signatures = 0
    let g:jedi#squelch_py_warning = 1
    let g:jedi#completions_enabled = 0

    function! s:jedi_vim_configure() abort
      setl omnifunc=jedi#completions
      setl completeopt=menu,longest

      nmap <buffer> <LocalLeader>g <Plug>(jedi-goto-assignments)
      nmap <buffer> <LocalLeader>d <Plug>(jedi-goto-definitions)
      nmap <buffer> <LocalLeader>R <Plug>(jedi-rename)
      nmap <buffer> <LocalLeader>n <Plug>(jedi-usage)
      nmap <buffer> K <Plug>(jedi-show-documentation)
    endfunction
    " Note:
    "   'FileType' could not be used while vim's default ftplugin/python.vim
    "   forecely call 'setl omnifunc=pythoncomplete#Complete' :-(
    autocmd MyAutoCmd BufEnter *.py call s:jedi_vim_configure()
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

if neobundle#tap('vim-pyenv') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'commands': [
        \     'PyenvActivate',
        \     'PyenvDeactivate',
        \   ],
        \   'filetypes': ['python', 'python3', 'djangohtml'],
        \ },
        \ 'external_commands': 'pyenv',
        \})
  function! neobundle#hooks.on_source(bundle) abort
    if neobundle#is_installed('jedi') && jedi#init_python()
      function! s:jedi_auto_force_py_version() abort
        let major_version = pyenv#python#get_internal_major_version()
        call jedi#force_py_version(major_version)
      endfunction
      autocmd MyAutoCmd User vim-pyenv-activate-post call s:jedi_auto_force_py_version()
      autocmd MyAutoCmd User vim-pyenv-deactivate-post call s:jedi_auto_force_py_version()
    endif
  endfunction
  call neobundle#untap()
endif " }}}

if neobundle#tap('SimpleFold') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'filetypes': ['python', 'python3', 'djangohtml'],
        \ }})
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-perl') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'filetypes': ['perl'],
        \ }})
  call neobundle#untap()
endif " }}}

if neobundle#tap('perldoc-vim') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'filetypes': ['perl'],
        \ }})
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-js-indent') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'filetypes': [
        \     'javascript',
        \     'typescript',
        \     'html',
        \     'djangohtml',
        \   ],
        \ }})
  call neobundle#untap()
endif " }}}

if neobundle#tap('typescript-vim') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'filetypes': [
        \     'typescript',
        \     'html',
        \     'djangohtml',
        \   ],
        \ }})
  function! neobundle#hooks.on_source(bundle) abort
    let g:typescript_indent_disable = 1
    let g:typescript_compiler_options = '-sourcemap'
  endfunction
  call neobundle#untap()
endif " }}}

if neobundle#tap('tsuquyomi') " {{{
  call neobundle#config({
        \ 'vim_version': '7.4',
        \ 'depends': 'Shougo/vimproc.vim',
        \ 'autoload': {
        \   'filetypes': 'typescript',
        \ },
        \ 'external_commands': 'node',
        \ 'build_commands': 'npm',
        \ 'build': {
        \   'mac':  'npm install -g typescript',
        \   'unix': 'npm install -g typescript',
        \ },
        \})
  function! neobundle#hooks.on_source(bundle) abort
    let g:typescript_indent_disable = 1
    let g:typescript_compiler_options = '-sourcemap'

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

if neobundle#tap('vim-pandoc') " {{{
  " Note:
  "   it seems vim-pandoc does not support has('python3')
  call neobundle#config({
        \ 'disabled': !has('python'),
        \ 'autoload': {
        \   'filetypes': [
        \     'text',
        \     'pandoc',
        \     'markdown',
        \     'rst',
        \   ],
        \ }})
  call neobundle#untap()
endif " }}}

if neobundle#tap('previm') " {{{
  call neobundle#config({
        \ 'depends': 'tyru/open-browser.vim',
        \ 'autoload': {
        \   'commands': [
        \     'PrevimOpen',
        \   ],
        \ },
        \})
  call neobundle#untap()
endif " }}}

" }}}

" misc {{{

if neobundle#tap('colorswatch.vim') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'commands': [
        \     'ColorSwatchGenerate',
        \   ],
        \ }})
  call neobundle#untap()
endif " }}}

" }}}

" Vim plugin development " {{{
if neobundle#tap('vim-themis') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'filetypes': [
        \     'vim', 'vimspec',
        \   ],
        \ }})

  function! neobundle#hooks.on_source(bundle) abort
    function! s:themis_settings() abort
      nnoremap <buffer> <Plug>(my-test) <Nop>
      nmap     <buffer> <LocalLeader>t <Plug>(my-test)
      nnoremap <buffer> <Plug>(my-test) :<C-u>call themis#run([expand('%')])<CR>
    endfunction
    autocmd MyAutoCmd FileType vim,vimspec call s:themis_settings()
  endfunction
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-prettyprint') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'commands': [
        \     'PP',
        \     'PrettyPrint',
        \   ],
        \   'functions': [
        \     'PP',
        \     'PrettyPrint',
        \   ],
        \ }})
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-vimlint') " {{{
  call neobundle#config({
        \ 'depends' : 'ynkdir/vim-vimlparser',
        \ 'autoload': {
        \   'filetypes': ['vim'],
        \ },
        \})
  function! neobundle#hooks.on_post_source(bundle) abort
    function! s:vimlint_settings() abort
      nnoremap <buffer> <Plug>(my-vimlint) <Nop>
      nmap     <buffer> <LocalLeader>l <Plug>(my-vimlint)
      nnoremap <buffer> <Plug>(my-vimlint) :<C-u>call vimlint#vimlint(expand('%'))<CR>
    endfunction
    autocmd MyAutoCmd FileType vim call s:vimlint_settings()
  endfunction

  call neobundle#untap()
endif " }}}
" }}}
