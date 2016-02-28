let s:dein_url = 'https://github.com/Shougo/dein.vim'
let s:dein_basepath = expand('$MYVIM_HOME/bundle')
let s:dein_abspath  = printf(
      \ '%s/repos/github.com/Shougo/dein.vim',
      \ s:dein_basepath,
      \)

function! s:configure() abort
  if has('vim_starting')
    execute printf('set runtimepath+=%s', fnameescape(s:dein_abspath))
  endif
  call dein#begin(s:dein_basepath)
  if dein#load_cache([
        \ expand('$MYVIM_VIMRC'),
        \ expand('$MYVIM_HOME/rc/dein/config.vim'),
        \ expand('$MYVIM_HOME/rc/dein/define.toml'),
        \])
    call dein#load_toml(
          \ expand('$MYVIM_HOME/rc/dein/define.toml'),
          \)
    call dein#save_cache()
  endif
  call vimrc#source_path(
        \ expand('$MYVIM_HOME/rc/dein/config.vim'),
        \)
  call dein#end()

  " Define commands
  function! s:complete_plugins(arglead, cmdline, cursorpos) abort
    return join(keys(dein#get()), "\n")
  endfunction
  command! -nargs=* -complete=custom,s:complete_plugins DeinInstall   call dein#install(split(<q-args>))
  command! -nargs=* -complete=custom,s:complete_plugins DeinReinstall call dein#reinstall(split(<q-args>))
  command! -nargs=* -complete=custom,s:complete_plugins DeinUpdate    call dein#update(split(<q-args>))
  command! DeinCheck
        \ if dein#check_install() |
        \   call dein#install() |
        \ endif
endfunction

if !isdirectory(s:dein_abspath)
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
else
  " dein.vim is installed
  call s:configure()
endif

" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker
