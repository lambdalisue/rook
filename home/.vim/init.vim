let s:file = expand('<sfile>:p')
let s:root = fnamemodify(s:file, ':h')
let s:is_windows = has('win16') || has('win32') || has('win64')
let s:separator = s:is_windows && !&shellslash ? '\' : '/'

" Source Vim's vimrc
execute printf('source %s', fnameescape(s:root . s:separator . 'vimrc'))

" Use <ESC> to escape from terminal mode
tnoremap <Esc> <C-\><C-n>

if exists('g:nyaovim_version')
  function! SetFullscreen(flag) abort
    call nyaovim#execute_javascript(join([
          \ '(function(){',
          \ '  const win = require("electron").remote.getCurrentWindow();',
          \ '  win.setFullScreen(' . a:flag . ');',
          \ '})()',
          \], '\n'))
  endfunction
  let fullscreen#start_command =
        \ 'call SetFullscreen(v:true)'
  let fullscreen#stop_command =
        \ 'call SetFullscreen(v:true)'
endif
