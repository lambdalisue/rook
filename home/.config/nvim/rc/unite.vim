call unite#custom#profile('default', 'context', {
      \ 'start_insert': 1,
      \ 'no_empty': 1,
      \})
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
call unite#custom#default_action('directory', 'cd')
call unite#custom#alias('file', 'edit', 'open')

" Do not limit candidate for grep
call unite#custom#source('grep', 'max_candidates', 0)
call unite#custom#source('grep/git', 'max_candidates', 0)

" grep
if executable('pt')
  " Use pt (the platinum searcher)
  " https://github.com/monochromegane/the_platinum_searcher
  let g:unite_source_grep_command = 'pt'
  let g:unite_source_grep_default_opts = '--nogroup --nocolor'
  let g:unite_source_grep_recursive_opt = ''
endif

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
  silent! nunmap <buffer> <C-n>
  silent! nunmap <buffer> <C-p>
  nmap <buffer><nowait> J <Plug>(unite_toggle_mark_current_candidate)
  vmap <buffer><nowait> J <Plug>(unite_toggle_mark_selected_candidate)

  " 'E' to open right
  nnoremap <silent><buffer><expr><nowait> E
        \ unite#smart_map('E', unite#do_action('right'))

  " force winfixheight
  setlocal winfixheight
endfunction
autocmd MyAutoCmd FileType unite call s:configure_unite()

" Alias
let g:unite_source_alias_aliases = {
      \ 'map': {
      \   'source': 'output',
      \   'args': 'map|map!|lmap',
      \ },
      \}

" File menu
function! s:register_filemenu(name, description, precursors) abort
  let t_string = type('')
  let candidates = []
  for precursor in a:precursors
    if type(precursor) == t_string
      call add(candidates, {
            \ 'word': '',
            \ 'abbr': '--- ' . precursor,
            \ 'kind': 'common',
            \ 'is_dummy': 1,
            \})
    else
      let path = expand(precursor[0])
      let desc = get(precursor, 1, '')
      let kind = isdirectory(path) ? 'directory' : 'file'
      let directory = isdirectory(path) ? path : fnamemodify(path, ':h')
      call add(candidates, {
            \ 'word': fnamemodify(path, ':~') . ' ' . desc,
            \ 'kind': kind,
            \ 'action__path': path,
            \ 'action__directory': directory,
            \})
    endif
  endfor
  let g:unite_source_menu_menus = get(g:, 'unite_source_menu_menus', {})
  let g:unite_source_menu_menus[a:name] = {
        \ 'description': a:description,
        \ 'candidates': candidates,
        \}
endfunction

call s:register_filemenu('shortcut', 'Shortcut menu', [
      \ 'rook',
      \ ['~/.homesick/repos/rook'],
      \ 'Neovim',
      \ ['~/.config/nvim/'],
      \ ['~/.config/nvim/ftplugin/'],
      \ ['~/.config/nvim/syntax/'],
      \ ['~/.config/nvim/template/'],
      \ ['~/.vimrc.local'],
      \ ['~/.gvimrc.local'],
      \ ['~/.config/nvim/init.vim'],
      \ ['~/.config/nvim/vimrc.min'],
      \ ['~/.config/nvim/filetype.vim'],
      \ ['~/.config/nvim/rc/dein.toml'],
      \ ['~/.config/nvim/rc/unite.vim'],
      \ ['~/.config/nvim/rc/denite.vim'],
      \ ['~/.config/nvim/rc/lexima.vim'],
      \ ['~/.config/nvim/rc/vimfiler.vim'],
      \ ['~/.config/nvim/rc/vimshell.vim'],
      \ ['~/.config/nvim/rc/lightline.vim'],
      \ 'Gvim',
      \ ['~/.config/nvim/gvimrc'],
      \ 'Nyaovim',
      \ ['~/.config/nyaovim/nyaovimrc.html'],
      \ ['~/.config/nyaovim/browser-config.json'],
      \ 'zsh',
      \ ['~/.config/zsh/'],
      \ ['~/.config/zsh/rc.d/'],
      \ ['~/.config/zsh/zshenv'],
      \ ['~/.config/zsh/zshrc'],
      \ ['~/.config/zsh/zplug.zsh'],
      \ ['~/.config/zsh/rc.d/10_config.zsh'],
      \ ['~/.config/zsh/rc.d/10_theme.zsh'],
      \ ['~/.config/zsh/rc.d/20_keymap.zsh'],
      \ ['~/.config/zsh/rc.d/50_config_fzf.zsh'],
      \ ['~/.config/zsh/rc.d/50_extend_rsync.zsh'],
      \ 'tmux',
      \ ['~/.config/tmux/'],
      \ ['~/.tmux.conf'],
      \ 'Karabiner',
      \ ['~/Library/Application Support/Karabiner/private.xml'],
      \ ['~/.karabiner.d/configuration/karabiner.json'],
      \ 'Reference',
      \ ['https://raw.githubusercontent.com/codemirror/CodeMirror/HEAD/keymap/vim.js'],
      \])
