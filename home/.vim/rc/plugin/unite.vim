scriptencoding utf-8

function! s:is_git_available() "{{{
  if !executable('git')
    return 0
  endif
  if neobundle#is_sourced('vim-gita')
    " faster way
    return gita#is_enabled()
  else
    call vimproc#system('git rev-parse')
    return (vimproc#get_last_status() == 0) ? 1 : 0
  endif
endfunction "}}}

function! neobundle#hooks.on_source(bundle)
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
  call unite#custom#profile('default', 'context', {
        \ 'prompt': '» ',
        \ 'start_insert': 1,
        \ 'no_empty': 1,
        \})
  call unite#custom#profile('action', 'context', {
        \ 'start_insert': 1,
        \ 'no_empty': 1,
        \})
  call unite#custom#profile('source/menu', 'context', {
        \ 'start_insert': 0,
        \ 'no_quit': 1,
        \})
  call unite#custom#default_action('directory', 'lcd')
  call unite#custom#alias('directory', 'narrow', 'lcd')
  call unite#custom#alias('file', 'edit', 'open')

  if neobundle#is_installed('agit.vim')
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
  endif
endfunction

function! s:configure_unite() abort
  let unite = unite#get_current_unite()

  " map 'r' to 'replace' or 'rename' action
  if unite.profile_name ==# 'search'
    nnoremap <silent><buffer><expr><nowait> r
          \ unite#smart_map('r', unite#do_action('replace'))
  else
    nnoremap <silent><buffer><expr><nowait> r
          \ unite#smart_map('r', unite#do_action('rename'))
  endif

  " 'jj' to leave insert mode
  imap <buffer><nowait> jj <Plug>(unite_insert_leave)

  " 'J' to select candidate instead of <Space> / <S-Space>
  nunmap <buffer> <Space>
  vunmap <buffer> <Space>
  nunmap <buffer> <S-Space>
  nmap <buffer><nowait> J <Plug>(unite_toggle_mark_current_candidate)
  vmap <buffer><nowait> J <Plug>(unite_toggle_mark_selected_candidate)

  " 'E' to open right
  nnoremap <silent><buffer><expr><nowait> E
        \ unite#smart_map('E', unite#do_action('right'))

  " force winfixheight
  setlocal winfixheight
endfunction
autocmd MyAutoCmd FileType unite call s:configure_unite()

" unite
nnoremap <Plug>(my-unite) <Nop>
nmap <Space> <Plug>(my-unite)
vmap <Space> <Plug>(my-unite)

nnoremap <silent> <Plug>(my-unite)<Space>
      \ :<C-u>UniteResume<CR>
nnoremap <silent> <Plug>(my-unite)w
      \ :<C-u>Unite buffer window tab<CR>
nnoremap <silent> <Plug>(my-unite)k
      \ :<C-u>Unite bookmark
      \ -buffer-name=vimfiler_opened<CR>
nnoremap <silent> <Plug>(my-unite)l :<C-u>Unite line
      \ -buffer-name=search<CR>
nnoremap <silent> <Plug>(my-unite)h :<C-u>Unite help
      \ -buffer-name=search<CR>
nnoremap <silent> <Plug>(my-unite)mp
      \ :<C-u>Unite output:map<BAR>map!<BAR>lmap
      \ -buffer-name=search<CR>
vnoremap <silent> <Plug>(my-unite)l
      \ :<C-u>UniteWithCursorWord line
      \ -buffer-name=search<CR>
vnoremap <silent> <Plug>(my-unite)h
      \ :<C-u>UniteWithCursorWord help
      \ -buffer-name=search<CR>

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
      \ :<C-u>Unite directory_rec/async
      \ -default-action=lcd<CR>
nnoremap <silent> <Plug>(my-unite-directory)i
      \ :<C-u>Unite directory
      \ -default-action=lcd<CR>
nnoremap <silent> <Plug>(my-unite-directory)m
      \ :<C-u>Unite directory_mru
      \ -default-action=lcd<CR>
nnoremap <silent> <Plug>(my-unite-directory)r
      \ :<C-u>Unite directory_rec/async
      \ -default-action=lcd<CR>

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
      \ :<C-u>call <SID>unite_smart_grep_cursor()<CR>
vnoremap <silent> <Plug>(my-unite-grep)*
      \ :<C-u>call <SID>unite_smart_grep_cursor()<CR>
nnoremap <silent> <Plug>(my-unite-grep)g
      \ :<C-u>call <SID>unite_smart_grep()<CR>
vnoremap <silent> <Plug>(my-unite-grep)g
      \ :<C-u>call <SID>unite_smart_grep_cursor()<CR>
nnoremap <silent> <Plug>(my-unite-grep)i
      \ :<C-u>Unite grep/git:/
      \ -buffer-name=search
      \ -no-empty<CR>
nnoremap <silent> <Plug>(my-unite-grep)r
      \ :<C-u>Unite grep:.
      \ -buffer-name=search
      \ -no-empty<CR>
function! s:unite_smart_grep()
  if s:is_git_available()
    Unite grep/git:/ -buffer-name=search
  else
    Unite grep:.     -buffer-name=search
  endif
endfunction
function! s:unite_smart_grep_cursor()
  if executable('git') && s:is_git_available()
    UniteWithCursorWord grep/git:/ -buffer-name=search
  else
    UniteWithCursorWord grep:.     -buffer-name=search
  endif
endfunction

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

" unite-menu
function! s:register_filemenu(name, description, precursors) abort " {{{
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
endfunction " }}}
call s:register_filemenu('shortcut', 'Shortcut menu', [
      \ ['rook'],
      \ [
      \   'rook',
      \   '~/.homesick/repos/rook',
      \ ],
      \ ['vim'],
      \ [
      \   'vimrc',
      \   fnamemodify($MYVIMRC, ':~'),
      \ ],
      \ [
      \   'gvimrc',
      \   fnamemodify($MYGVIMRC, ':~'),
      \ ],
      \ [
      \   'rc/plugin.vim',
      \   fnamemodify($MYVIMRUNTIME . '/rc/plugin.vim', ':~'),
      \ ],
      \ [
      \   'rc/plugin.define.vim',
      \   fnamemodify($MYVIMRUNTIME . '/rc/plugin.define.vim', ':~'),
      \ ],
      \ [
      \   'rc/plugin.config.vim',
      \   fnamemodify($MYVIMRUNTIME . '/rc/plugin.config.vim', ':~'),
      \ ],
      \ [
      \   'rc/plugin/lightline.vim',
      \   fnamemodify($MYVIMRUNTIME . '/rc/plugin/lightline.vim', ':~'),
      \ ],
      \ [
      \   'rc/plugin/unite.vim',
      \   fnamemodify($MYVIMRUNTIME . '/rc/plugin/unite.vim', ':~'),
      \ ],
      \ [
      \   'rc/plugin/vimfiler.vim',
      \   fnamemodify($MYVIMRUNTIME . '/rc/plugin/vimfiler.vim', ':~'),
      \ ],
      \ [
      \   'rc/plugin/vimshell.vim',
      \   fnamemodify($MYVIMRUNTIME . '/rc/plugin/vimshell.vim', ':~'),
      \ ],
      \ [
      \   'vim',
      \   fnamemodify($MYVIMRUNTIME, ':~'),
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
      \   'tmux.osx.conf',
      \   '~/.tmux.osx.conf',
      \ ],
      \ [
      \   'tmux',
      \   '~/.config/tmux',
      \ ],
      \])
nnoremap <silent> <Plug>(my-unite)s :<C-u>Unite menu:shortcut<CR>
