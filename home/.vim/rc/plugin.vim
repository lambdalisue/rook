let s:remote_bundle_root = $MYVIMRUNTIME . '/bundle'
let s:neobundle_root     = s:remote_bundle_root . '/neobundle.vim'
let s:neobundle_url      = 'https://github.com/Shougo/neobundle.vim'

function! s:install_neobundle() abort
  if !executable('git')
    echohl Error
    echo 'git is required to be installed.'
    echohl None
    return 1
  endif

  redraw | echo 'Installing neobundle.vim ...'
  call system(printf('git clone %s %s', s:neobundle_url, s:neobundle_root))
  execute printf('set runtimepath+=%s', s:neobundle_root)
  call s:configure_neobundle()
  redraw | echo 'Done. Call :NeoBundleCheck to install missing plugins.'
  return 0
endfunction

function! s:configure_neobundle() abort
  call neobundle#begin(s:remote_bundle_root)
  if neobundle#load_cache()
    call MyLoadSource($MYVIMRUNTIME . '/rc/plugin.define.vim')
    NeoBundleSaveCache
  endif
  call MyLoadSource($MYVIMRUNTIME . '/rc/plugin.config.vim')
  call neobundle#end()
  if !has('vim_starting')
    "call neobundle#call_hook('on_source')
  endif
endfunction

if !filereadable(s:neobundle_root . '/plugin/neobundle.vim')
  command! InstallNeoBundle call s:install_neobundle()
  redraw | echo 'Need plugins? Use :InstallNeoBundle'
else
  if has('vim_starting')
    execute printf('set runtimepath+=%s', s:neobundle_root)
  endif
  call s:configure_neobundle()
endif
filetype plugin indent on
syntax on

" vim:set et ts=2 sts=2 sw=2 tw=0 fdm=marker:
