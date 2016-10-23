" <C-z> is used in tmux so remap it to <C-s>
call denite#custom#map('insert', "\<C-s>", 'suspend')

" grep
if executable('pt')
  " Use pt (the platinum searcher)
  " https://github.com/monochromegane/the_platinum_searcher
  call denite#custom#var('grep', 'command', ['pt'])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'final_opts', [])
  call denite#custom#var('grep', 'separator', [])
  call denite#custom#var('grep', 'default_opts', [
        \ '--nocolor', '--nogroup', '--column',
        \])
endif

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
      \ '~/Library/Application Support/Karabiner/private.xml',
      \ '~/.karabiner.d/configuration/karabiner.json',
      \ 'https://raw.githubusercontent.com/codemirror/CodeMirror/HEAD/keymap/vim.js',
      \])
call denite#custom#var('menu', 'menus', s:menus)
