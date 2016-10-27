call unite#custom#profile('default', 'context', {
      \ 'start_insert': 1,
      \ 'no_empty': 1,
      \})
call unite#custom#default_action('directory', 'cd')
call unite#custom#alias('file', 'edit', 'open')

" grep
if executable('pt')
  " Use pt (the platinum searcher)
  " https://github.com/monochromegane/the_platinum_searcher
  let g:unite_source_grep_command = 'pt'
  let g:unite_source_grep_default_opts = '--nogroup --nocolor'
  let g:unite_source_grep_recursive_opt = ''
endif

" Alias
let g:unite_source_alias_aliases = {
      \ 'map': {
      \   'source': 'output',
      \   'args': 'map|map!|lmap',
      \ },
      \}

function! s:unite_my_settings() abort
  silent! iunmap <buffer> <C-p>
  silent! iunmap <buffer> <C-n>
  silent! nunmap <buffer> <C-p>
  silent! nunmap <buffer> <C-n>
  imap <buffer> <C-t> <Plug>(unite_select_previous_line)
  imap <buffer> <C-g> <Plug>(unite_select_next_line)
  nmap <buffer> <C-t> <Plug>(unite_loop_cursor_up)
  nmap <buffer> <C-g> <Plug>(unite_loop_cursor_down)
endfunction
autocmd MyAutoCmd FileType unite call s:unite_my_settings()


function! s:build_filemenu(description, precursors) abort
  let candidates = []
  for precursor in a:precursors
    if type(precursor) == type('')
      call add(candidates, [precursor, precursor])
    else
      call add(candidates, precursor)
    endif
  endfor
  let menu = {'description': a:description}
  let menu.file_candidates = candidates
  return menu
endfunction

let s:menus = {}
let s:menus.shortcut = s:build_filemenu('Shortcut menu:', [
      \ '~/.homesick/repos/rook',
      \ '~/.config/nvim/',
      \ '~/.config/nvim/ftplugin/',
      \ '~/.config/nvim/syntax/',
      \ '~/.config/nvim/template/',
      \ '~/.vimrc.local',
      \ '~/.gvimrc.local',
      \ '~/.config/nvim/init.vim',
      \ '~/.config/nvim/vimrc.min',
      \ '~/.config/nvim/filetype.vim',
      \ '~/.config/nvim/rc.d/dein.toml',
      \ '~/.config/nvim/rc.d/unite.vim',
      \ '~/.config/nvim/rc.d/denite.vim',
      \ '~/.config/nvim/rc.d/lexima.vim',
      \ '~/.config/nvim/rc.d/vimfiler.vim',
      \ '~/.config/nvim/rc.d/vimshell.vim',
      \ '~/.config/nvim/rc.d/lightline.vim',
      \ '~/.config/nvim/ftplugin/vim.vim',
      \ '~/.config/nvim/ftplugin/perl.vim',
      \ '~/.config/nvim/ftplugin/python.vim',
      \ '~/.config/nvim/ftplugin/jason.vim',
      \ '~/.config/nvim/ftplugin/javascript.vim',
      \ '~/.config/nvim/ftplugin/typescript.vim',
      \ '~/.config/nvim/ftplugin/xslate.vim',
      \ '~/.config/nvim/ftplugin/help.vim',
      \ '~/.config/nvim/ftplugin/html.vim',
      \ '~/.config/nvim/gvimrc',
      \ '~/.config/nyaovim/nyaovimrc.html',
      \ '~/.config/nyaovim/browser-config.json',
      \ '~/.config/zsh/',
      \ '~/.config/zsh/rc.d/',
      \ '~/.config/zsh/zshenv',
      \ '~/.config/zsh/zshrc',
      \ '~/.config/zsh/tmux.zsh',
      \ '~/.config/zsh/zplug.zsh',
      \ '~/.config/zsh/bookmark.txt',
      \ '~/.config/zsh/rc.d/10_config.zsh',
      \ '~/.config/zsh/rc.d/10_theme.zsh',
      \ '~/.config/zsh/rc.d/20_keymap.zsh',
      \ '~/.config/zsh/rc.d/50_config_fzf.zsh',
      \ '~/.config/zsh/rc.d/50_extend_rsync.zsh',
      \ '~/.config/zsh/rc.d/90_functions.zsh',
      \ '~/.config/tmux/',
      \ '~/.config/tmux/tmux.conf',
      \ '~/.config/tmux/rc.d/00_keymap.conf',
      \ '~/.config/tmux/rc.d/50_plugin.conf',
      \ '~/.gitconfig',
      \ '~/.gitignore',
      \ '~/.vimperatorrc',
      \ '~/Library/Application Support/Karabiner/private.xml',
      \ '~/.karabiner.d/configuration/karabiner.json',
      \ 'https://raw.githubusercontent.com/codemirror/CodeMirror/HEAD/keymap/vim.js',
      \])
let g:unite_source_menu_menus = s:menus
