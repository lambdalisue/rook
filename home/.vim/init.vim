let s:file = expand('<sfile>:p')
let s:root = fnamemodify(s:file, ':h')
let s:is_windows = has('win16') || has('win32') || has('win64')
let s:separator = s:is_windows && !&shellslash ? '\' : '/'

" Source Vim's vimrc
execute printf('source %s', fnameescape(s:root . s:separator . 'vimrc'))

function! s:set_guifont(fontconf, force) abort
  call rpcnotify(0, 'Gui', 'SetFont', a:fontconf, a:force)
endfunction
command! -nargs=* -bang Guifont call s:set_guifont(<q-args>, <q-bang> ==# '!')

" Workaround for GUIEnter {{{
if exists('#GUIEnter')
  echohl WarningMsg
  echomsg 'GUIEnter autocmd exists. Time to remove workaround.'
  echohl None
endif
if !exists('g:_nvim_qt_GUIEnter')
  augroup nvim_qt_GUIEnter_workaround
    autocmd! *
    autocmd FocusGained *
          \ doautocmd <nomodeline> User GUIEnter |
          \ let g:_nvim_qt_GUIEnter = 1 |
          \ autocmd! nvim_qt_GUIEnter_workaround
  augroup END
endif
" }}}

augroup nvim_gui_fontset
  autocmd! *
  autocmd User GUIEnter Guifont! Ricty for Powerline:h9
augroup END
