scriptencoding utf-8

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
if has('multi_byte') && $LANG !=# 'C'
  let config = {
        \ 'prompt': '» ',
        \ 'candidate_icon': '⋮',
        \ 'marked_icon': '✓',
        \ 'no_hide_icon': 1,
        \}
else
  let config = {
        \ 'prompt': '> ',
        \ 'candidate_icon': ' ',
        \ 'marked_icon': '*',
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

" Alias
let g:unite_source_alias_aliases = {
      \ 'map': {
      \   'source': 'output',
      \   'args': 'map|map!|lmap',
      \ },
      \}

" add unite interface
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
      \   fnamemodify(resolve($MYVIM_VIMRC), ':~'),
      \ ],
      \ [
      \   'gvimrc',
      \   fnamemodify(resolve($MYVIM_GVIMRC), ':~'),
      \ ],
      \ [
      \   'init.vim',
      \   fnamemodify(expand('$MYVIM_HOME/init.vim'), ':~'),
      \ ],
      \ [
      \   'vimshrc',
      \   fnamemodify(expand('$MYVIM_HOME/vimshrc'), ':~'),
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
      \   'rc/dein.vim',
      \   fnamemodify(expand('$MYVIM_HOME/rc/dein.vim'), ':~'),
      \ ],
      \ [
      \   'rc/dein/define.toml',
      \   fnamemodify(expand('$MYVIM_HOME/rc/dein/define.toml'), ':~'),
      \ ],
      \ [
      \   'rc/dein/config.vim',
      \   fnamemodify(expand('$MYVIM_HOME/rc/dein/config.vim'), ':~'),
      \ ],
      \ [
      \   'rc/neobundle.vim',
      \   fnamemodify(expand('$MYVIM_HOME/rc/neobundle.vim'), ':~'),
      \ ],
      \ [
      \   'rc/neobundle/define.toml',
      \   fnamemodify(expand('$MYVIM_HOME/rc/neobundle/define.toml'), ':~'),
      \ ],
      \ [
      \   'rc/neobundle/config.vim',
      \   fnamemodify(expand('$MYVIM_HOME/rc/neobundle/config.vim'), ':~'),
      \ ],
      \ [
      \   'rc/config/unite.vim',
      \   fnamemodify(expand('$MYVIM_HOME/rc/config/unite.vim'), ':~'),
      \ ],
      \ [
      \   'rc/config/vimfiler.vim',
      \   fnamemodify(expand('$MYVIM_HOME/rc/config/vimfiler.vim'), ':~'),
      \ ],
      \ [
      \   'rc/config/vimshell.vim',
      \   fnamemodify(expand('$MYVIM_HOME/rc/config/vimshell.vim'), ':~'),
      \ ],
      \ [
      \   'vim',
      \   fnamemodify(expand('$MYVIM_HOME'), ':~'),
      \ ],
      \ [
      \   'bundle',
      \   fnamemodify(expand('$MYVIM_HOME/bundle'), ':~'),
      \ ],
      \ [
      \   'ftplugin',
      \   fnamemodify(expand('$MYVIM_HOME/ftplugin'), ':~'),
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


" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker
