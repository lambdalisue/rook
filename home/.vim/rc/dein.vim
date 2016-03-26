let s:dein_url = 'https://github.com/Shougo/dein.vim'
let s:dein_basepath = expand('$MYVIM_HOME/bundle')
let s:dein_abspath  = printf(
      \ '%s/repos/dein.vim',
      \ s:dein_basepath,
      \)
let s:dein_localpath = printf('%s/local', s:dein_basepath)

function! s:configure() abort
  execute printf('set runtimepath+=%s', fnameescape(s:dein_abspath))
  if dein#load_state(s:dein_basepath)
    call dein#begin(s:dein_basepath, [
          \ expand('$MYVIM_VIMRC'),
          \ expand('$MYVIM_GVIMRC'),
          \ expand('$MYVIM_HOME/rc/dein/define.toml'),
          \ expand('$MYVIM_HOME/rc/dein/config.vim'),
          \ expand('$MYVIM_HOME/rc/dein/command.vim'),
          \])
    call dein#load_toml(expand('$MYVIM_HOME/rc/dein/define.toml'))
    call dein#local(s:dein_localpath, {
          \ 'frozen': 1,
          \ 'merged': 0,
          \})
    call dein#end()
    call dein#save_state()
  else
    call dein#call_hook('source')
    call dein#call_hook('post_source')
  endif
  call vimrc#source_path(expand('$MYVIM_HOME/rc/dein/config.vim'))
  call vimrc#source_path(expand('$MYVIM_HOME/rc/dein/command.vim'))
endfunction

if isdirectory(s:dein_abspath)
  call s:configure()
  finish
endif

" dein.vim is missing
function! s:install() abort
  if !executable('git')
    echohl ErrorMsg
    echo '"git" is not executable. You need to install "git" first.'
    echohl None
    return 1
  endif

  redraw | echo 'Installing Shougo/dein.vim ...'
  " Check if a parent directory is available and make if not
  let parent_directory = fnamemodify(s:dein_abspath, ':h')
  if !isdirectory(parent_directory)
    call mkdir(parent_directory, 'p')
  endif
  call system(printf('git clone %s %s',
        \ s:dein_url, fnameescape(s:dein_abspath),
        \))
  call s:configure()
endfunction
command! Install call s:install()
redraw
echo 'Do you need plugins? Use ":Install" to install "Shougo/dein.vim"'

" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker
