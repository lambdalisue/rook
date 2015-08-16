function! s:is_git_available() "{{{
  if !executable('git')
    return 0
  endif
  if neobundle#is_sourced('vim-gita')
    return gita#is_enabled()
  endif
  call vimproc#system('git rev-parse')
  return (vimproc#get_last_status() == 0) ? 1 : 0
endfunction "}}}
function! s:is_hg_available() "{{{
  if !executable('hg')
    return 0
  endif
  call vimproc#system('hg root')
  return (vimproc#get_last_status() == 0) ? 1 : 0
endfunction "}}}

noremap [operator] <Nop>
map - [operator]

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

if neobundle#tap('vim-hier') " {{{
  call neobundle#config({
        \ 'disabled': 1,
        \ })
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-template') " {{{
  function! neobundle#tapped.hooks.on_source(bundle)
    function! s:template_eval_vimscript() abort
      silent %s/<%=\(.\{-}\)%>/\=eval(submatch(1))/ge
    endfunction
    function! s:template_move_cursor() abort
      if search('<+CURSOR+>', 'cw')
        silent execute 'normal! "_da>'
      endif
    endfunction
    autocmd User plugin-template-loaded call s:template_eval_vimscript()
    autocmd User plugin-template-loaded call s:template_move_cursor()
  endfunction
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-unified-diff') " {{{
  call neobundle#config({
        \ 'external_commands': 'git',
        \ })
  function! neobundle#tapped.hooks.on_source(bundle)
    let unified_diff#arguments = [
          \   'diff', '--no-index', '--no-color', '--no-ext-diff', '--unified=0',
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

  nnoremap [quickhl] <Nop>
  xnoremap [quickhl] <Nop>
  nmap H [quickhl]
  xmap H [quickhl]

  nmap [quickhl]h <Plug>(quickhl-manual-this)
  xmap [quickhl]h <Plug>(quickhl-manual-this)
  nmap [quickhl]r <Plug>(quickhl-manual-reset)
  xmap [quickhl]r <Plug>(quickhl-manual-reset)

  nmap [quickhl]H  <Plug>(quickhl-manual-toggle)
  xmap [quickhl]H  <Plug>(quickhl-manual-toggle)
  nmap [quickhl]c  <Plug>(quickhl-cword-toggle)
  nmap [quickhl]t  <Plug>(quickhl-tag-toggle)

  map  [operator]h <Plug>(operator-quickhl-manual-this-motion)

  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-choosewin') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'mappings': '<Plug>(choosewin)',
        \   'commands': [
        \     'ChooseWin',
        \     'ChooseWinSwap',
        \     'ChooseWinSwapStay',
        \   ],
        \ }})

  function! neobundle#tapped.hooks.on_source(bundle)
    " overlay is slow in termianl
    if has('gui_running')
      let g:choosewin_overlay_enable = 1
      let g:choosewin_overlay_clear_multibyte = 1
    endif
  endfunction

  nnoremap [choosewin] <Nop>
  nmap ! <Plug>(choosewin)

  call neobundle#untap()
endif " }}}

if neobundle#tap('open-browser.vim') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'mappings': '<Plug>(openbrowser-',
        \ }})

  function! neobundle#tapped.hooks.on_source(bundle)
    let g:netrw_nogx = 1  " disable netrw's gx mapping
  endfunction

  nnoremap [openbrowser] <Nop>
  nmap gx [openbrowser]
  vmap gx [openbrowser]
  nmap [openbrowser] <Plug>(openbrowser-smart-search)
  vmap [openbrowser] <Plug>(openbrowser-smart-search)

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
  function! s:source_vim_over()
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

  function! neobundle#tapped.hooks.on_source(bundle)
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
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:clever_f_smart_case = 1
    let g:clever_f_not_overwrite_standard_mappings = 1
  endfunction

  map f <Plug>(clever-f-f)
  map F <Plug>(clever-f-F)
  map T <Plug>(clever-f-T)
  map t <Plug>(clever-f-t)

  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-smalls') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'mappings': '<Plug>(smalls)',
        \ }})

  function! neobundle#tapped.hooks.on_source(bundle)
    let excursion_table_custom = {
          \ ';': 'do_jump',
          \ "\<CR>": 'do_set',
          \ "\<C-n>": 'do_next',
          \ "\<C-p>": 'do_prev',
          \ }
    call smalls#keyboard#excursion#extend_table(excursion_table_custom)
  endfunction

  map m <Plug>(smalls)
  omap m <Plug>(smalls)
  xmap m <Plug>(smalls)

  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-asterisk') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'mappings': '<Plug>(asterisk-',
        \ }})

  map / <Plug>(incsearch-forward)
  map ? <Plug>(incsearch-backward)
  map g/ <Plug>(incsearch-stay)
  map n <Plug>(incsearch-nohl-n)
  map N <Plug>(incsearch-nohl-N)

  map *   <Plug>(asterisk-*)
  map #   <Plug>(asterisk-#)
  map g*  <Plug>(asterisk-g*)
  map g#  <Plug>(asterisk-g#)
  map z*  <Plug>(asterisk-z*)
  map gz* <Plug>(asterisk-gz*)
  map z#  <Plug>(asterisk-z#)
  map gz# <Plug>(asterisk-gz#)

  call neobundle#untap()
endif " }}}

if neobundle#tap('incsearch.vim') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'mappings': '<Plug>(incsearch-',
        \ }})

  function! neobundle#tapped.hooks.on_source(bundle)
    let g:incsearch#auto_nohlsearch = 1
    let g:incsearch#magic = '\v'
  endfunction

  map / <Plug>(incsearch-forward)
  map ? <Plug>(incsearch-backward)
  map g/ <Plug>(incsearch-stay)
  map n <Plug>(incsearch-nohl-n)
  map N <Plug>(incsearch-nohl-N)

  map * <Plug>(incsearch-nohl-*)
  map # <Plug>(incsearch-nohl-#)
  map g* <Plug>(incsearch-nohl-g*)
  map g# <Plug>(incsearch-nohl-g#)

  call neobundle#untap()
endif " }}}

if neobundle#tap('deoplete.nvim') " {{{
  call neobundle#config({
        \ 'disabled': !has('nvim'),
        \ 'autoload': {
        \   'insert': 1,
        \ }})

  function! neobundle#tapped.hooks.on_source(bundle)
    let g:deoplete#enable_at_startup = 1
    let g:deoplete#enable_smart_case = 1
    let g:deoplete#enable_underbar_completion = 1
    let g:deoplete#enable_auto_close_preview = 0
  endfunction

  call neobundle#untap()
endif " }}}

if neobundle#tap('neocomplete.vim') " {{{
  call neobundle#config({
        \ 'disabled': has('nvim'),
        \ 'autoload': {
        \   'insert': 1,
        \ }})

  function! neobundle#tapped.hooks.on_source(bundle)
    let g:neocomplete#enable_at_startup = 1
    let g:neocomplete#enable_smart_case = 1
    let g:neocomplete#enable_underbar_completion = 1
    let g:neocomplete#enable_auto_close_preview = 0
  endfunction

  call neobundle#untap()
endif " }}}

if neobundle#tap('neoinclude.vim') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'on_source': 'neocomplete.vim',
        \ }})

  call neobundle#untap()
endif " }}}

if neobundle#tap('neco-vim') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'filetype': ['vim', 'vimspec'],
        \ }})

  call neobundle#untap()
endif " }}}

if neobundle#tap('echodoc.vim') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'insert': 1,
        \ }})

  function! neobundle#tapped.hooks.on_source(bundle)
    set cmdheight=2
    set completeopt+=menuone
    "set completeopt-=preview
    let g:echodoc_enable_at_startup=1
  endfunction

  call neobundle#untap()
endif " }}}

if neobundle#tap('neosnippet.vim') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'mappings': '<Plug>(neosnippet_expand',
        \ }})

  function! neobundle#tapped.hooks.on_source(bundle)
    let g:neosnippet#snippets_directory = $MY_VIMRUNTIME. '/snippets'

    " for snippet complete marker
    if has('conceal')
      set conceallevel=2 concealcursor=i
    endif
  endfunction

  " Plugin key-mappings.
  imap <C-k> <Plug>(neosnippet_expand_or_jump)
  smap <C-k> <Plug>(neosnippet_expand_or_jump)
  xmap <C-k> <Plug>(neosnippet_expand_target)

  call neobundle#untap()
endif " }}}

if neobundle#tap('yankround.vim') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'mappings': '<Plug>(yankround-',
        \ }})

  function! neobundle#tapped.hooks.on_source(bundle)
    let g:yankround_use_region_hl = 1
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
        \ 'augroup': 'bm_vim_enter',
        \ 'autoload': {
        \   'mappings': '<Plug>Bookmark',
        \   'unite_sources': 'vim_bookmarks',
        \ }})
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:bookmark_auto_save = 1
    let g:bookmark_save_per_working_dir = 1
    let g:bookmark_highlight_lines = 0
    " use 'long' converter to show actual file path
    call unite#custom_source(
          \ 'vim_bookmarks',
          \ 'converters',
          \ 'converter_vim_bookmarks_long')
  endfunction

  nnoremap [bookmark] <Nop>
  nmap M [bookmark]
  vmap M [bookmark]
  nmap [bookmark]m <Plug>BookmarkToggle
  nmap [bookmark]i <Plug>BookmarkAnnotate
  vmap [bookmark]m <Plug>BookmarkToggle
  vmap [bookmark]i <Plug>BookmarkAnnotate
  nmap [bookmark]n <Plug>BookmarkNext
  nmap [bookmark]p <Plug>BookmarkPrev
  nmap [bookmark]a <Plug>BookmarkShowAll
  nmap [bookmark]c <Plug>BookmarkClear
  nmap [bookmark]x <Plug>BookmarkClearAll

  nmap ]m <Plug>BookmarkNext
  nmap [m <Plug>BookmarkPrev
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-quickrun') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'mappings': '<Plug>(quickrun',
        \ }})

  function! neobundle#tapped.hooks.on_source(bundle)
    let g:quickrun_config = get(g:, 'quickrun_config', {})
    let g:quickrun_config['_'] = {
          \ 'runner' : 'vimproc',
          \ 'outputter/buffer/split': ':botright 8sp',
          \ 'outputter/buffer/close_on_empty': 1,
          \ 'hook/time/enable': 1,
          \}

    " Terminate the quickrun with <C-c>
    nnoremap <expr><silent> <C-c>
          \ quickrun#is_running() ? quickrun#sweep_sessions() : "\<C-c>"

  endfunction

  nnoremap [quickrun] <Nop>
  nmap <LocalLeader>r [quickrun]
  nmap [quickrun] <Plug>(quickrun)

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

  vnoremap [linediff] <Nop>
  nnoremap [linediff] <Nop>
  vmap <S-l> [linediff]
  nmap <S-l> [linediff]
  nmap [linediff]d v$:<C-u>Linediff<CR>
  nmap [linediff]r :<C-u>LinediffReset<CR>
  vmap [linediff]d :<C-u>'<,'>Linediff<CR>
  vmap [linediff]r :<C-u>LinediffReset<CR>

  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-swap') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'mappings': '<Plug>SwapSwap',
        \ }})

  function! neobundle#tapped.hooks.on_source(bundle)
    let g:swap_enable_default_keymaps = 0
  endfunction

  nnoremap [swap] <Nop>
  vnoremap [swap] <Nop>
  nmap ~ [swap]
  vmap ~ [swap]
  vmap [swap]~  <Plug>SwapSwapOperands
  vmap [swap]-  <Plug>SwapSwapPivotOperands
  nmap [swap]~  <Plug>SwapSwapWithR_WORD
  nmap [swap]-  <Plug>SwapSwapWithL_WORD

  call neobundle#untap()
endif " }}}

" }}}

" statusline {{{

if neobundle#tap('lightline.vim') " {{{
  function! neobundle#tapped.hooks.on_source(bundle) " {{{
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
          \     [ 'pyenv', 'git_branch', 'git_traffic', 'git_status', 'cwd' ],
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
          \   'mode': 'g:lightline.my.mode',
          \   'cwd': 'g:lightline.my.cwd',
          \   'filename': 'g:lightline.my.filename',
          \   'fileformat': 'g:lightline.my.fileformat',
          \   'fileencoding': 'g:lightline.my.fileencoding',
          \   'filetype': 'g:lightline.my.filetype',
          \   'git_branch': 'g:lightline.my.git_branch',
          \   'git_traffic': 'g:lightline.my.git_traffic',
          \   'git_status': 'g:lightline.my.git_status',
          \   'pyenv': 'g:lightline.my.pyenv',
          \ },
          \}
    let g:lightline.my = {}
    let g:lightline.my.symbols = {}
    if $LANG == "C"
      let g:lightline.my.symbols.branch = ''
      let g:lightline.my.symbols.readonly = '!!'
    else
      let g:lightline.my.symbols.branch = '⭠'
      let g:lightline.my.symbols.readonly = '⭤'
    endif
    let g:lightline.my.symbols.modified = '+'
    let g:lightline.my.symbols.nomodifiable = '!'
    let g:lightline.my.featured_filetype_pattern = printf('^\%%(%s\)', join([
          \ 'help', 'qf',
          \ 'unite', 'vimfiler', 'vimshell',
          \ 'tagbar',
          \ 'gita-.\+', 'gista-.\+',
          \], '\|'))
    let g:lightline.my.featured_bufname_pattern = printf('^\%%(%s\)', join([
          \ '__Tagbar__',
          \], '\|'))
    function! g:lightline.my.is_featured() " {{{
      " check filetype
      if &filetype =~# self.featured_filetype_pattern
        return 1
      endif
      " check filename
      if expand('%:t') =~# self.featured_bufname_pattern
        return 1
      endif
      return 0
    endfunction " }}}
    function! g:lightline.my.mode() " {{{
      return lightline#mode()
    endfunction " }}}
    function! g:lightline.my.modified() " {{{
      return self.is_featured() ? '' :
            \ &modified ? self.symbols.modified :
            \ &modifiable ? '' : self.symbols.nomodifiable
    endfunction " }}}
    function! g:lightline.my.readonly() " {{{
      return self.is_featured() ? '' :
            \ &readonly ? self.symbols.readonly : ''
    endfunction " }}}
    function! g:lightline.my.cwd() " {{{
      return fnamemodify(getcwd(), ':~')
    endfunction " }}}
    function! g:lightline.my.filename() " {{{
      if self.is_featured()
        if &filetype ==# 'unite'
          return unite#get_status_string()
        elseif &filetype ==# 'vimfiler'
          return vimfiler#get_status_string()
        elseif &filetype ==# 'vimshell'
          return vimshell#get_status_string()
        else
          return ''
        endif
      else
        let fname = winwidth(0) > 70 ? expand('%') : pathshorten(expand('%'))
        return '' .
              \ ('' != self.readonly() ? self.readonly() . ' ' : '') .
              \ ('' != fname ? fname : '[No name]') .
              \ ('' != self.modified() ? ' ' . self.modified() : '')
      endif
    endfunction " }}}
    function! g:lightline.my.fileformat() " {{{
      return winwidth(0) > 70 ? &fileformat : ''
    endfunction " }}}
    function! g:lightline.my.filetype() " {{{
      return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
    endfunction " }}}
    function! g:lightline.my.fileencoding() "{{{
      return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
    endfunction " }}}
    function! g:lightline.my.git_branch() " {{{
      if neobundle#is_sourced('vim-gita')
        return gita#statusline#preset('branch_fancy')
      else
        return ''
      endif
    endfunction " }}}
    function! g:lightline.my.git_traffic() " {{{
      if neobundle#is_sourced('vim-gita')
        return gita#statusline#preset('traffic_fancy')
      else
        return ''
      endif
    endfunction " }}}
    function! g:lightline.my.git_status() " {{{
      if neobundle#is_sourced('vim-gita')
        return gita#statusline#preset('status')
      else
        return ''
      endif
    endfunction " }}}
    function! g:lightline.my.pyenv() " {{{
      if neobundle#is_sourced('vim-pyenv')
        return pyenv#info#preset('long')
      else
        return ''
      endif
    endfunction " }}}

    " do not use ordinal showmode
    set noshowmode
  endfunction " }}}
  function! neobundle#tapped.hooks.on_post_source(bundle)
    call lightline#update()
  endfunction
  call neobundle#untap()
endif " }}}

if neobundle#tap('lightline-hybrid.vim') " {{{
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-watchdogs') " {{{
  call neobundle#config({
        \ })

  function! neobundle#tapped.hooks.on_source(bundle)
    let g:watchdogs_check_BufWritePost_enable = 0
    let g:watchdogs_check_BufWritePost_enable_on_wq = 0
    let g:watchdogs_check_CursorHold_enable = 0

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
    " configure quickrun
    call watchdogs#setup(g:quickrun_config)
  endfunction
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-qfstatusline') " {{{
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
  function! neobundle#tapped.hooks.on_source(bundle)
    function! s:textobj_python_settings()
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

  map <silent> [operator]r <Plug>(operator-replace)

  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-operator-openbrowser') " {{{
  call neobundle#config({
        \ 'depends': 'kana/vim-operator-user',
        \ 'autoload': {
        \   'mappings': '<Plug>(operator-openbrowser',
        \ }})
  map <silent> [operator]x <Plug>(operator-openbrowser)
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-operator-trailingspace-killer') " {{{
  call neobundle#config({
        \ 'depends': 'kana/vim-operator-user',
        \ 'autoload': {
        \   'mappings': '<Plug>(operator-trailingspace-killer',
        \ }})
  map <silent> [operator]k <Plug>(operator-trailingspace-killer)
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-operator-surround') " {{{
  call neobundle#config({
        \ 'depends': 'kana/vim-operator-user',
        \ 'autoload': {
        \   'mappings': '<Plug>(operator-surround',
        \ }})

  function! neobundle#tapped.hooks.on_source(bundle)
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

  map <silent> [operator]sa <Plug>(operator-surround-append)
  map <silent> [operator]sd <Plug>(operator-surround-delete)
  map <silent> [operator]sr <Plug>(operator-surround-replace)

  nmap <silent> [operator]sdd
        \ <Plug>(operator-surround-delete)<Plug>(textobj-multiblock-a)
  nmap <silent> [operator]srr
        \ <Plug>(operator-surround-replace)<Plug>(textobj-multiblock-a)
  vmap <silent> [operator]sdd
        \ <Plug>(operator-surround-delete)<Plug>(textobj-multiblock-a)
  vmap <silent> [operator]srr
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

  function! neobundle#tapped.hooks.on_source(bundle)
    call unite#custom#profile('default', 'context', {
          \ 'prompt': '» ',
          \ 'start_insert': 1,
          \})
    call unite#custom#profile('action', 'context', {
          \ 'start_insert': 1,
          \})

    let g:unite_kind_jump_list_after_jump_scroll = 0
    let g:unite_source_grep_max_candidates = 500
    if executable('pt')
      " use pt (The Platinum Searcher) for grep (prefer)
      let g:unite_source_grep_command = 'pt'
      let g:unite_source_grep_default_opts = join([
            \ '--smart-case',
            \ '--nogroup',
            \ '--nocolor',
            \ '--follow',
            \ '-e',
            \], ' ')
      let g:unite_source_grep_recursive_opt = ''
    endif

    " Configuration per buffer
    function! s:my_unite_configure()
      setlocal winfixheight
      let unite = unite#get_current_unite()
      if unite.profile_name ==# 'search'
        nnoremap <silent><buffer><expr> r
              \ unite#smart_map('r', unite#do_action('replace'))
      else
        nnoremap <silent><buffer><expr> r
              \ unite#smart_map('r', unite#do_action('rename'))
      endif
      imap <buffer> jj      <Plug>(unite_insert_leave)
      " Use 'J' instead of <Space>
      nunmap <buffer> <Space>
      nunmap <buffer> <S-Space>
      vunmap <buffer> <Space>
      nmap <buffer> J <Plug>(unite_toggle_mark_current_candidate)
      vmap <buffer> J <Plug>(unite_toggle_mark_selected_candidates)
    endfunction
    autocmd MyAutoCmd FileType unite call s:my_unite_configure()
  endfunction

  nnoremap [unite] <Nop>
  nmap <Space> [unite]
  vmap <Space> [unite]
  nnoremap <silent> [unite]<Space>
        \ :<C-u>UniteResume<CR>
  nnoremap <silent> [unite]w
        \ :<C-u>Unite buffer window tab<CR>
  nnoremap <silent> [unite]k
        \ :<C-u>Unite bookmark
        \ -buffer-name=vimfiler_opened<CR>
  nnoremap <silent> [unite]l :<C-u>Unite line
        \ -buffer-name=search<CR>
  nnoremap <silent> [unite]h :<C-u>Unite help
        \ -buffer-name=search<CR>
  nnoremap <silent> [unite]mp
        \ :<C-u>Unite output:map<BAR>map!<BAR>lmap
        \ -buffer-name=search<CR>
  vnoremap <silent> [unite]l
        \ :<C-u>UniteWithCursorWord line
        \ -buffer-name=search<CR>
  vnoremap <silent> [unite]h
        \ :<C-u>UniteWithCursorWord help
        \ -buffer-name=search<CR>

  " unite-file
  nnoremap [unite-file] <Nop>
  nmap [unite]f [unite-file]
  nnoremap <silent> [unite-file]f
        \ :<C-u>call <SID>unite_smart_file()<CR>
  nnoremap <silent> [unite-file]i
        \ :<C-u>Unite file<CR>
  nnoremap <silent> [unite-file]m
        \ :<C-u>Unite file_mru<CR>
  nnoremap <silent> [unite-file]r
        \ :<C-u>Unite file_rec/async<CR>
  nnoremap <silent> [unite-file]g
        \ :<C-u>Unite file_rec/git<CR>
  function! s:unite_smart_file()
    if executable('git') && s:is_git_available()
      Unite file_rec/git -buffer-name=search
    else
      Unite file_rec/async -buffer-name=search
    endif
  endfunction

  " unite-directory
  nnoremap [unite-directory] <Nop>
  nmap [unite]d [unite-directory]
  nnoremap <silent> [unite-directory]d
        \ :<C-u>Unite directory_rec/async
        \ -default-action=lcd<CR>
  nnoremap <silent> [unite-directory]i
        \ :<C-u>Unite directory
        \ -default-action=lcd<CR>
  nnoremap <silent> [unite-directory]m
        \ :<C-u>Unite directory_mru
        \ -default-action=lcd<CR>
  nnoremap <silent> [unite-directory]r
        \ :<C-u>Unite directory_rec/async
        \ -default-action=lcd<CR>

  " unite-qf
  if neobundle#is_installed('unite-quickfix')
    nnoremap [unite-qf] <Nop>
    nmap [unite]q [unite-qf]
    nnoremap <silent> [unite-qf]q
          \ :<C-u>Unite quickfix location_list
          \ -buffer-name=search<CR>
    nnoremap <silent> [unite-qf]f
          \ :<C-u>Unite quickfix
          \ -buffer-name=search<CR>
    nnoremap <silent> [unite-qf]l
          \ :<C-u>Unite location_list
          \ -buffer-name=search<CR>
  endif

  " unite-grep
  nnoremap [unite-grep] <Nop>
  nmap [unite]g [unite-grep]
  vmap [unite]g [unite-grep]
  nnoremap <silent> [unite-grep]*
        \ :<C-u>call <SID>unite_smart_grep_cursor()<CR>
  vnoremap <silent> [unite-grep]*
        \ :<C-u>call <SID>unite_smart_grep_cursor()<CR>
  nnoremap <silent> [unite-grep]g
        \ :<C-u>call <SID>unite_smart_grep()<CR>
  vnoremap <silent> [unite-grep]g
        \ :<C-u>call <SID>unite_smart_grep_cursor()<CR>
  nnoremap <silent> [unite-grep]i
        \ :<C-u>Unite grep/git:/
        \ -buffer-name=search
        \ -no-empty<CR>
  nnoremap <silent> [unite-grep]h
        \ :<C-u>Unite grep/hg:/
        \ -buffer-name=search
        \ -no-empty<CR>
  nnoremap <silent> [unite-grep]r
        \ :<C-u>Unite grep:.
        \ -buffer-name=search
        \ -no-empty<CR>
  function! s:unite_smart_grep()
    if executable('git') && s:is_git_available()
      Unite grep/git:/ -buffer-name=search -no-empty
    elseif executable('hg') && s:is_hg_available()
      Unite grep/hg:/ -buffer-name=search -no-empty
    else
      Unite grep:. -buffer-name=search -no-empty
    endif
  endfunction
  function! s:unite_smart_grep_cursor()
    if executable('git') && s:is_git_available()
      UniteWithCursorWord grep/git:/ -buffer-name=search -no-empty
    elseif executable('hg') && s:is_hg_available()
      UniteWithCursorWord grep/hg:/ -buffer-name=search -no-empty
    else
      UniteWithCursorWord grep:. -buffer-name=search -no-empty
    endif
  endfunction

  " unite-git
  nnoremap [unite-git] <Nop>
  nmap [unite]i [unite-git]
  if neobundle#is_installed('vim-unite-giti')
    nnoremap <silent> [unite-git]i
          \ :<C-u>Unite giti<CR>
    nnoremap <silent> [unite-git]b
          \ :<C-u>Unite giti/branch<CR>
    nnoremap <silent> [unite-git]l
          \ :<C-u>Unite giti/log<CR>
    nnoremap <silent> [unite-git]r
          \ :<C-u>Unite giti/remote<CR>
    nnoremap <silent> [unite-git]s
          \ :<C-u>Unite giti/status<CR>
    nnoremap <silent> [unite-git]pb
          \ :<C-u>Unite giti/pull_request/base<CR>
    nnoremap <silent> [unite-git]ph
          \ :<C-u>Unite giti/pull_request/head<CR>
  endif
  if neobundle#is_installed('vim-gista')
    nnoremap <silent> [unite-git]t
          \ :<C-u>Unite gista:lambdalisue<CR>
  endif

  " unite-ref
  nnoremap [unite-ref] <Nop>
  nmap [unite]r [unite-ref]
  if neobundle#is_installed('vim-ref')
    nnoremap <silent> [unite-ref]r
                \ :<C-u>call <SID>unite_smart_ref()<CR>
    nnoremap <silent> [unite-ref]p
                \ :<C-u>Unite ref/pydoc<CR>
    nnoremap <silent> [unite-ref]l
                \ :<C-u>Unite perldoc<CR>
    nnoremap <silent> [unite-ref]m
                \ :<C-u>Unite ref/man<CR>
    if neobundle#is_installed('ref-sources.vim')
      nnoremap <silent> [unite-ref]j
                  \ :<C-u>Unite ref/javascript<CR>
      nnoremap <silent> [unite-ref]q
                  \ :<C-u>Unite ref/jquery<CR>
      nnoremap <silent> [unite-ref]k
                  \ :<C-u>Unite ref/kotobank<CR>
      nnoremap <silent> [unite-ref]w
                  \ :<C-u>Unite ref/wikipedia<CR>
    endif
    function! s:unite_smart_ref()
      if &filetype =~ 'perl'
        Unite perldoc
      elseif &filetype =~ 'python'
        Unite ref/pydoc
      elseif &filetype =~ 'ruby'
        Unite ref/refe
      elseif &filetype =~ 'javascript'
        Unite ref/javascript
      elseif &filetype =~ 'vim'
        Unite help
      else
        Unite ref/man
      endif
    endfunction
  endif

  " unite-linephrase
  if neobundle#is_installed('unite-linephrase')
    nnoremap <silent> [unite]p :<C-u>Unite linephrase
          \ -buffer-name=search<CR>
  endif

  " unite-outline
  if neobundle#is_installed('unite-outline')
    " Use outline like explorer
    nnoremap <silent> <Leader>o :<C-u>Unite
          \ -no-quit -keep-focus -no-start-insert
          \ -vertical -direction=botright -winwidth=30 outline<CR>
  endif

  " vim-bookmarks
  if neobundle#is_installed('vim-bookmarks')
    nnoremap <silent> [unite]mm :<C-u>Unite vim_bookmarks<CR>
  endif

  " unite-menu
  function! s:register_quickmenu(name, description, candidate_precursors) " {{{
    " find the length of longest name
    let max_length = max(map(filter(
          \ deepcopy(a:candidate_precursors),
          \ printf('v:val[0] != "%s"', '-'),
          \), 'len(v:val[0])'))
    " create candidates
    let candidates = []
    for precursor in a:candidate_precursors
      if len(precursor) == 1
        " Separator
        call add(candidates, [
              \ precursor[0],
              \ '',
              \])
      elseif len(precursor) == 2
        " Acttion (short)
        call add(candidates, [
              \ printf(
              \   printf("%%-%ds : %%s", max_length),
              \   precursor[0], precursor[1]
              \ ),
              \ precursor[0],
              \])
      elseif len(precursor) == 3
        " Action
        call add(candidates, [
              \ printf(
              \   printf("%%-%ds : %%s", max_length),
              \   precursor[0], precursor[1]
              \ ),
              \ precursor[2],
              \])
      endif
    endfor
    let separator_length = max(map(
          \ deepcopy(candidates),
          \ 'len(v:val[0])',
          \))
    if separator_length % 2 != 0
      let separator_length += 1
    endif
    " register to 'g:unite_source_menu_menus'
    let g:unite_source_menu_menus = get(g:, 'unite_source_menu_menus', {})
    let g:unite_source_menu_menus[a:name] = {}
    let g:unite_source_menu_menus[a:name].description = a:description
    let g:unite_source_menu_menus[a:name].candidates = deepcopy(candidates)
    let g:unite_source_menu_menus[a:name].separator_length = max(map(
          \ deepcopy(candidates),
          \ 'len(v:val[0])',
          \))

    function! g:unite_source_menu_menus[a:name].map(key, value) abort " {{{
      if empty(a:value[1])
        if empty(a:value[0])
          let word = repeat('-', self.separator_length)
        else
          let length = self.separator_length - (len(a:value[0]) + 3)
          let word = printf('- %s %s', a:value[0], repeat('-', length))
        endif
        return {
              \ 'word': '',
              \ 'abbr': word,
              \ 'kind': 'common', 'is_dummy': 1,
              \}
      else
        return {
              \ 'word': a:value[0],
              \ 'kind': 'command',
              \ 'action__command': a:value[1],
              \}
      endif
    endfunction " }}}
  endfunction " }}}

  call s:register_quickmenu('shortcut', 'Shortcut menu', [
        \ ['Application'],
        \ ['Calendar', 'Open Calendar'],
        \ ['Configuration'],
        \ ['vimrc', 'Open vimrc', printf('edit %s', $MYVIMRC)],
        \ ['gvimrc', 'Open gvimrc', printf('edit %s', $MYGVIMRC)],
        \ ['vimrc.local', 'Open local vimrc',
        \   printf('edit %s', expand('~/.vimrc.local'))],
        \ ['neobundle-define.vim', 'Open neobundle definitions',
        \   printf('edit %s', resolve($MY_VIMRUNTIME . '/rc/neobundle.define.vim'))],
        \ ['neobundle-config.vim', 'Open neobundle configuration',
        \   printf('edit %s', resolve($MY_VIMRUNTIME . '/rc/neobundle.config.vim'))],
        \ ['gitconfig', 'Open global git configuration',
        \   printf('edit %s', expand('~/.gitconfig'))],
        \ ['gitignore', 'Open global gitignore configuration',
        \   printf('edit %s', expand('~/.gitignore'))],
        \ ['Directory'],
        \ ['vim', 'lcd to vim directory',
        \   printf('lcd %s', $MY_VIMRUNTIME)],
        \ ['zsh', 'lcd to zsh directory',
        \   printf('lcd %s', expand('~/.config/zsh'))],
        \ ['tmux', 'lcd to tmux directory',
        \   printf('lcd %s', expand('~/.config/tmux'))],
        \])
  nnoremap <silent> [unite]s :<C-u>Unite menu:shortcut<CR>

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

  nnoremap [vimshell] <Nop>
  nmap <C-s> [vimshell]
  vmap <C-s> [vimshell]
  nnoremap <silent> [vimshell]s :<C-u>VimShellPop<CR>
  nnoremap <silent> [vimshell]S :<C-u>VimShellTab<CR>
  nnoremap <silent> [vimshell]i :<C-u>VimShellInteractive<CR>
  nnoremap <silent> [vimshell]p :<C-u>VimShellInteractive ipython<CR>
  nnoremap <silent> [vimshell]<Space> :<C-u>VimShellSendString<CR>
  vnoremap <silent> [vimshell]<Space> :<C-u>VimShellSendString<CR>

  function! neobundle#tapped.hooks.on_source(bundle)
    let g:vimshell_prompt = '$ '
    let g:vimshell_secondary_prompt = '| '
    let g:vimshell_vimshrc_path = $MY_VIMRUNTIME .  '/vimshrc'
    " use zsh history
    if exists(expand('~/.config/zsh/.zsh_history'))
      let g:vimshell_external_history_path =
            \ expand('~/.config/zsh/.zsh_history')
    endif

    autocmd MyAutoCmd FileType vimshell call s:my_vimshell_settings()
    function! s:my_vimshell_settings()
      " Initialize execute file list.
      call vimshell#set_execute_file('rb', 'ruby')
      call vimshell#set_execute_file('pl', 'perl')
      call vimshell#set_execute_file('py', 'python')
      call vimshell#set_execute_file('js', 'node')
      call vimshell#set_execute_file('coffee', 'coffee')
      call vimshell#set_execute_file('jpg,jpeg,gif,png,tiff,tif', 'evince open')
      call vimshell#set_execute_file('html,xhtml', 'chrome gexe firefox')

      xmap <buffer> y <Plug>(operator-concealedyank)
      imap <buffer> ^^ cd ..<CR>
      imap <buffer> [[ popd<CR>

      inoremap <buffer><silent><C-r> <Esc>:<C-u>Unite
            \ -buffer-name=history
            \ -default-action=execute
            \ -no-split
            \ vimshell/history vimshell/external_history<CR>
      inoremap <buffer><silent><C-x><C-j> <Esc>:<C-u>Unite
            \ -buffer-name=files
            \ -default-action=lcd
            \ -no-split
            \ directory_mru<CR>

      call vimshell#hook#add('chpwd', 'my_chpwd', s:vimshell_hooks.chpwd)
      call vimshell#hook#add('emptycmd', 'my_emptycmd', s:vimshell_hooks.emptycmd)
      call vimshell#hook#add('preexec', 'my_preexec', s:vimshell_hooks.preexec)
    endfunction

    let s:vimshell_hooks = {}
    function! s:vimshell_hooks.chpwd(args, context)
      if len(split(glob('*'), '\n')) < 100
        call vimshell#execute('ls')
      else
        call vimshell#execute('echo "Many files."')
      endif
    endfunction
    function! s:vimshell_hooks.emptycmd(cmdline, context)
      call vimshell#execute('ls')
    endfunction
    function! s:vimshell_hooks.preexec(cmdline, context)
      let args = vimproc#parser#split_args(a:cmdline)
      if len(args) > 0 && args[0] ==# 'diff'
        call vimshell#set_syntax('diff')
      endif
      return a:cmdline
    endfunction
  endfunction

  function! neobundle#tapped.hooks.on_post_source(bundle)
    highlight! vimshellError gui=NONE cterm=NONE guifg='#cc6666' ctermfg=9
  endfunction
  call neobundle#untap()
endif " }}}

if neobundle#tap('vimfiler.vim') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'commands': [
        \     'VimFiler',
        \     'VimFilerExplorer',
        \   ],
        \   'explorer': 1,
        \ }})

  nnoremap [vimfiler] <Nop>
  nmap <Leader>e [vimfiler]
  nnoremap <silent> [vimfiler]e :<C-u>VimFilerExplorer<CR>
  nnoremap <silent> [vimfiler]E :<C-u>VimFiler<CR>

  function! neobundle#tapped.hooks.on_source(bundle)
    call vimfiler#custom#profile('default', 'context', {
          \ 'auto_cd': 1,
          \ 'parent': 1,
          \ 'safe': 0,
          \ })
    let g:vimfiler_as_default_explorer = 1
    " ignore swap, backup, temporary files
    let g:vimfiler_ignore_pattern = printf('\%%(%s\)', join([
          \ '^\..*',
          \ '\.pyc$',
          \ '^__pycache__$',
          \ '\.egg-info$',
          \], "\\|"))

    function! s:vimfiler_settings()
      setl nonumber
      " Use 'J' to select candidate while <Space> is for Unite
      nunmap <buffer> <Space>
      nunmap <buffer> <S-Space>
      vunmap <buffer> <Space>
      nmap <buffer> J <Plug>(vimfiler_toggle_mark_current_line)
      vmap <buffer> J <Plug>(vimfiler_toggle_mark_selected_lines)
      " ^^ to go parent directory
      nmap <buffer> ^^ <Plug>(vimfiler_switch_to_parent_directory)
      " X to execute on the directory
      nmap <buffer> X
            \ <Plug>(vimfiler_switch_to_parent_directory)
            \ <Plug>(vimfiler_execute_system_associated)
            \ <Plug>(vimfiler_execute)
      " <Space>k to open bookmark
      nmap <buffer><silent> <Space>k :<C-u>Unite bookmark
            \ -buffer-name=vimfiler_opened<CR>
    endfunction
    autocmd MyAutoCmd FileType vimfiler call s:vimfiler_settings()

    " Use 'lcd' on directory kind if the Unite is opend from vimfiler
    " It is quite useful to lcd to bookmarked directory
    let smart_open = {
          \ 'is_selectable': 0,
          \}
    function! smart_open.func(candidate)
      let context = unite#get_context()
      if context.buffer_name == 'vimfiler_opened'
        call unite#take_action(g:unite_kind_cdable_lcd_command, a:candidate)
      else
        call unite#take_action(self.default_action, a:candidate)
      endif
    endfunction
    " store default_action of 'directory'
    let smart_open.default_action =
          \ unite#get_kinds('directory').default_action
    call unite#custom#action('directory', 'smart_open', smart_open)
    call unite#custom#default_action('directory', 'smart_open')
  endfunction
  call neobundle#untap()
endif " }}}

if neobundle#tap('undotree.vim') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'commands': [
        \     'UndotreeToggle',
        \   ],
        \ }})

  nnoremap [undotree] <Nop>
  nmap <Leader>u [undotree]
  nnoremap <silent> [undotree] :<C-u>UndotreeToggle<CR>

  function! neobundle#tapped.hooks.on_source(bundle)
  endfunction
  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-ref') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'commands': [
        \     'Ref',
        \   ],
        \ }})

  function! neobundle#tapped.hooks.on_source(bundle)
    let g:ref_open = 'vsplit'
    function! s:ref_configure()
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

  function! neobundle#tapped.hooks.on_source(bundle)
    let g:ref_jquery_doc_path = $MY_VIMRUNTIME. '/bundle/jqapi'
    let g:ref_javascript_doc_path = $MY_VIMRUNTIME. '/bundle/jsref/htdocs'
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

  nnoremap [tagbar] <Nop>
  nmap <Leader>t [tagbar]
  nnoremap <silent> [tagbar] :<C-u>TagbarToggle<CR>
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

  nnoremap [memolist] <Nop>
  nmap <Leader>m [memolist]
  nnoremap <silent> [memolist]m :<C-u>MemoList<CR>
  nnoremap <silent> [memolist]n :<C-u>MemoNew<CR>
  nnoremap <silent> [memolist]g :<C-u>MemoGrep<CR>

  function! neobundle#tapped.hooks.on_source(bundle)
    let g:memolist_qfixgrep = 1
    let g:memolist_path = expand('~/Dropbox/Apps/Byword/')
    let g:memolist_unite = 1
    let g:memolist_unite_option = "-no-start-insert"
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

  nnoremap [tabular] <Nop>
  vnoremap [tabular] <Nop>
  nmap <Leader>a [tabular]
  vmap <Leader>a [tabular]
  nnoremap [tabular]= :<C-u>Tabularize /=<CR>
  vnoremap [tabular]= :<C-u>Tabularize /=<CR>
  nnoremap [tabular]> :<C-u>Tabularize /=><CR>
  vnoremap [tabular]> :<C-u>Tabularize /=><CR>
  nnoremap [tabular]# :<C-u>Tabularize /#<CR>
  vnoremap [tabular]# :<C-u>Tabularize /#<CR>
  nnoremap [tabular]! :<C-u>Tabularize /!<CR>
  vnoremap [tabular]! :<C-u>Tabularize /!<CR>
  nnoremap [tabular]" :<C-u>Tabularize /"<CR>
  vnoremap [tabular]" :<C-u>Tabularize /"<CR>
  nnoremap [tabular]& :<C-u>Tabularize /&<CR>
  vnoremap [tabular]& :<C-u>Tabularize /&<CR>
  nnoremap [tabular]: :<C-u>Tabularize /:\zs<CR>
  vnoremap [tabular]: :<C-u>Tabularize /:\zs<CR>
  nnoremap [tabular]<BAR> :<C-u>Tabularize /<BAR><CR>
  vnoremap [tabular]<BAR> :<C-u>Tabularize /<BAR><CR>
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

  function! neobundle#tapped.hooks.on_source(bundle)
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

  nnoremap [rengbang] <Nop>
  vmap <C-a> [rengbang]
  vnoremap [rengbang]a :<C-u>'<,'>RengBang<CR>
  vnoremap [rengbang]A :<C-u>'<,'>RengBangUsePrev<CR>
  vnoremap [rengbang]c :<C-u>'<,'>RengBangConfirm<CR>

  map [operator]rr <Plug>(operator-rengbang)
  map [operator]rR <Plug>(operator-rengbang-useprev)
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

  function! neobundle#tapped.hooks.on_source(bundle)
    let g:colorizer_nomap = 1
  endfunction

  call neobundle#untap()
endif " }}}
" }}}

" unite sources {{{
function! s:configure_neobundle_sources(sources)
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
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:linephrase#directory = expand("~/Copy/Apps/Vim/linephrase")
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
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:gita#features#browse#extra_translation_patterns = [
          \ ['\vhttps?://(ghe\.admin\.h)/(.{-})/(.{-})%(\.git)?$',
          \  'https://\1/\2/\3/blob/%br/%pt%{#L|}ls%{-L|}le'],
          \ ['\vgit://(ghe\.admin\.h)/(.{-})/(.{-})%(\.git)?$',
          \  'https://\1/\2/\3/blob/%br/%pt%{#L|}ls%{-L|}le'],
          \ ['\vgit\@(ghe\.admin\.h):(.{-})/(.{-})%(\.git)?$',
          \  'https://\1/\2/\3/blob/%br/%pt%{#L|}ls%{-L|}le'],
          \ ['\vssh://git\@(ghe\.admin\.h)/(.{-})/(.{-})%(\.git)?$',
          \  'https://\1/\2/\3/blob/%br/%pt%{#L|}ls%{-L|}le'],
          \]
  endfunction

  nnoremap [gita] <Nop>
  nmap <Leader>a [gita]
  nnoremap [gita]a :<C-u>Gita status  --ignore-submodules<CR>
  nnoremap [gita]s :<C-u>Gita status<CR>
  nnoremap [gita]c :<C-u>Gita commit<CR>
  nnoremap [gita]d :<C-u>Gita diff    --ignore-submodules -- %<CR>
  nnoremap [gita]l :<C-u>Gita diff-ls --ignore-submodules<CR>

  call neobundle#untap()
endif " }}}

if neobundle#tap('vim-gitgutter') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'commands': [
        \     'GitGutterPrevHunk',
        \     'GitGutterNextHunk',
        \     'GitGutterToggle',
        \   ],
        \ }})

  function! neobundle#tapped.hooks.on_source(bundle)
    let g:gitgutter_enabled = 0
    let g:gitgutter_sign_added = '+'
    let g:gitgutter_sign_modified = '~'
    let g:gitgutter_sign_removed = '-'
    let g:gitgutter_map_keys = 0
  endfunction

  nmap [g <Plug>GitGutterPrevHunk
  nmap ]g <Plug>GitGutterNextHunk
  nmap [switch]g :<C-u>GitGutterToggle<CR>

  call neobundle#untap()
endif " }}}

if neobundle#tap('agit.vim') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'on_source': 'unite.vim',
        \   'commands': [
        \     'Agit',
        \     'AgitFile',
        \   ],
        \ }})

  function neobundle#hooks.on_source(bundle)
    " add extra key-mappings
    function! s:my_agit_setting()
      nmap <buffer> ch <Plug>(agit-git-cherry-pick)
      nmap <buffer> Rv <Plug>(agit-git-revert)
    endfunction
    autocmd MyAutoCmd FileType agit call s:my_agit_setting()
  endfunction

  function neobundle#hooks.on_post_source(bundle)
    " add unite interface
    let agit = {
          \ 'description': 'open the directory (or parent directory) in agit',
          \ }
    function! agit.func(candidate)
      if isdirectory(a:candidate.action__path)
        let path = a:candidate.action__path
      else
        let path = fnamemodify(a:candidate.action__path, ':h')
      endif
      execute 'Agit' '--dir=' . path
    endfunction

    let agit_file = {
          \ 'description': "open the file's history in agit.vim",
          \ }
    function! agit_file.func(candidate)
      execute 'AgitFile' '--file=' . a:candidate.action__path
    endfunction

    call unite#custom#action('file,cdable', 'agit', agit)
    call unite#custom#action('file', 'agit_file', agit_file)
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

if neobundle#tap('vim-fugitive') " {{{
  call neobundle#config({
        \ 'disabled': 1,
        \ })
  function! neobundle#tapped.hooks.on_post_source(bundle)
  endfunction
  call neobundle#untap()
endif " }}}

if neobundle#tap('committia.vim') " {{{
  call neobundle#config({
        \ 'depends': [
        \ ],
        \ 'autoload': {
        \   'mappings': '<Plug>(committia-',
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

  function! neobundle#tapped.hooks.on_source(bundle)
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

    function! s:latexbox_configure()
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
  function! neobundle#tapped.hooks.on_source(bundle)
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

  function! neobundle#tapped.hooks.on_source(bundle)
    let g:jedi#auto_initialization = 0
    let g:jedi#auto_vim_configuration = 0
    let g:jedi#popup_on_dot = 0
    let g:jedi#popup_select_first = 0
    let g:jedi#auto_close_doc = 0
    let g:jedi#show_call_signatures = 0
    let g:jedi#squelch_py_warning = 1
    let g:jedi#completions_enabled = 0

    function! s:jedi_vim_configure()
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
        \ 'focus': 1,
        \ 'autoload': {
        \   'commands': [
        \     'PyenvActivate',
        \     'PyenvDeactivate',
        \   ],
        \   'filetypes': ['python', 'python3', 'djangohtml'],
        \ },
        \ 'external_commands': 'pyenv',
        \})
  function! neobundle#tapped.hooks.on_source(bundle)
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
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:typescript_indent_disable = 1
    let g:typescript_compiler_options = '-sourcemap'
  endfunction
  call neobundle#untap()
endif " }}}

if neobundle#tap('tsuquyomi') " {{{
  call neobundle#config({
        \ 'disabled': v:version < 704,
        \ 'depends': ['Shougo/vimproc.vim'],
        \ 'autoload': {
        \   'filetypes': [
        \     'typescript',
        \   ],
        \ },
        \ 'external_commands': 'node',
        \ 'build_commands': 'npm',
        \ 'build': {
        \   'mac'     : 'npm install -g typescript',
        \   'unix'    : 'npm install -g typescript',
        \ }})
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:typescript_indent_disable = 1
    let g:typescript_compiler_options = '-sourcemap'

    function! s:tsuquyomi_configure()
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

if neobundle#tap('vim-json') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'filetypes': [
        \     'json',
        \   ],
        \ },
        \ 'external_commands': 'git',
        \ })
  function! neobundle#tapped.hooks.on_post_source(bundle)
    autocmd MyAutoCmd FileType json Vison
  endfunction
  call neobundle#untap()
endif " }}}

if neobundle#tap('vison') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'filetypes': [
        \     'json',
        \   ],
        \ },
        \ 'external_commands': 'git',
        \ })
  function! neobundle#tapped.hooks.on_post_source(bundle)
    autocmd MyAutoCmd FileType json Vison
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

if neobundle#tap('shareboard.vim') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'commands': [
        \     'ShareboardPreview',
        \     'ShareboardCompile',
        \   ],
        \ },
        \ 'external_commands': 'shareboard',
        \ 'build_commands': 'pip',
        \ 'build': {
        \   'mac'     : 'pip install shareboard',
        \   'unix'    : 'pip install shareboard',
        \ }})

  function! neobundle#tapped.hooks.on_source(bundle)
    let txt2html = expand('~/.config/zsh/tools/txt2html/txt2html')
    if filereadable(txt2html)
      let g:shareboard_command = txt2html
    endif
  endfunction

  " register the call rules
  function! s:shareboard_settings()
    nnoremap <buffer> [shareboard] <Nop>
    nmap     <buffer> <LocalLeader>S [shareboard]
    nnoremap <buffer> [shareboard]v :<C-u>ShareboardPreview<CR>
    nnoremap <buffer> [shareboard]c :<C-u>ShareboardCompile<CR>
  endfunction
  autocmd MyAutoCmd FileType pandoc,rst,text,markdown
        \ call s:shareboard_settings()
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

if neobundle#tap('vinarise.vim') " {{{
  call neobundle#config({
        \ 'autoload': {
        \   'commands': [
        \     'Vinarise',
        \     'VinarisePluginDump',
        \     'VinarisePluginViewBitmapView',
        \   ],
        \ }})
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:vinarise_enable_auto_detect = 1
  endfunction
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

  function! neobundle#tapped.hooks.on_source(bundle)
    function! s:themis_settings()
      nnoremap <buffer> [test] <Nop>
      nmap     <buffer> <LocalLeader>t [test]
      nnoremap <buffer> [test] :<C-u>call themis#run([expand('%')])<CR>
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
        \ }})
  function! neobundle#tapped.hooks.on_source(bundle)
    function! s:vimlint_settings()
      nnoremap <buffer> [vimlint] <Nop>
      nmap     <buffer> <LocalLeader>l [vimlint]
      nnoremap <buffer> [vimlint] :<C-u>call vimlint#vimlint(expand('%'))<CR>
    endfunction
    autocmd MyAutoCmd FileType vim call s:vimlint_settings()
  endfunction

  call neobundle#untap()
endif " }}}
" }}}
