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

if has('mac')
  augroup nvim_gui_fontset
    autocmd! *
    autocmd User GUIEnter GuiFont! Ricty\ for\ Powerline:h11
  augroup END
else
  augroup nvim_gui_fontset
    autocmd! *
    autocmd User GUIEnter GuiFont! Ricty\ for\ Powerline:h9
  augroup END
endif

let g:fullscreen#start_command = "call rpcnotify(0, 'Gui', 'WindowFullScreen', 1)"
let g:fullscreen#stop_command = "call rpcnotify(0, 'Gui', 'WindowFullScreen', 0)"


" Set GUI font
function! GuiFont(fname, ...) abort
  let force = get(a:000, 0, 0)
  call rpcnotify(0, 'Gui', 'Font', a:fname, force)
endfunction

" The GuiFont command. For compatibility there is also Guifont
function s:GuiFontCommand(fname, bang) abort
  if a:fname ==# ''
    if exists('g:GuiFont')
      echo g:GuiFont
    else
      echo 'No GuiFont is set'
    endif
  else
    call GuiFont(a:fname, a:bang ==# '!')
  endif
endfunction
command! -nargs=? -bang Guifont call s:GuiFontCommand("<args>", "<bang>")
command! -nargs=? -bang GuiFont call s:GuiFontCommand("<args>", "<bang>")
