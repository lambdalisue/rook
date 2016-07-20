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
  autocmd User GUIEnter GuiFont! Ricty for Powerline:h8
augroup END

let g:fullscreen#start_command = "call rpcnotify(0, 'Gui', 'WindowFullScreen', 1)"
let g:fullscreen#stop_command = "call rpcnotify(0, 'Gui', 'WindowFullScreen', 0)"

