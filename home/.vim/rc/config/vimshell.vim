scriptencoding utf-8

let g:vimshell_prompt = '$ '
let g:vimshell_secondary_prompt = '| '

let s:zsh_history_path = expand('~/.config/zsh/.zsh_history')
if filereadable(s:zsh_history_path)
  let g:vimshell_external_history_path = s:zsh_history_path
endif

let s:vimshell_hooks = {}
function! s:vimshell_hooks.chpwd(args, context) abort
  if len(split(glob('*'), '\n')) < 100
    call vimshell#execute('ls')
  else
    call vimshell#execute('echo "Many files."')
  endif
endfunction
function! s:vimshell_hooks.emptycmd(cmdline, context) abort
  call vimshell#execute('ls')
endfunction
function! s:vimshell_hooks.preexec(cmdline, context) abort
  let args = vimproc#parser#split_args(a:cmdline)
  if len(args) > 0 && args[0] ==# 'diff'
    call vimshell#set_syntax('diff')
  endif
  return a:cmdline
endfunction

function! s:configure_vimshell() abort
  " Initialize execute file list.
  call vimshell#set_execute_file('rb', 'ruby')
  call vimshell#set_execute_file('pl', 'perl')
  call vimshell#set_execute_file('py', 'python')
  call vimshell#set_execute_file('js', 'node')
  call vimshell#set_execute_file('coffee', 'coffee')

  nmap <buffer><silent> q :<C-u>close<CR>
  imap <buffer> ^^ cd ..<CR>
  imap <buffer> [[ popd<CR>
  nmap <buffer> <Up>   <Plug>(vimshell_previous_prompt)
  nmap <buffer> <Down> <Plug>(vimshell_next_prompt)
  " NOTE:
  " it seems <Plug>(vimshell_history_neocomplete) does not work with deoplete?
  if has('nvim')
    nmap <buffer> <C-p>  <Plug>(vimshell_insert_head)<Plug>(vimshell_history_unite)
    nmap <buffer> <C-n>  <Plug>(vimshell_insert_head)<Plug>(vimshell_history_unite)
    imap <buffer> <C-p>  <Plug>(vimshell_history_unite)
    imap <buffer> <C-n>  <Plug>(vimshell_history_unite)
  else
    nmap <buffer> <C-p>  <Plug>(vimshell_insert_head)<Plug>(vimshell_history_neocomplete)
    nmap <buffer> <C-n>  <Plug>(vimshell_insert_head)<Plug>(vimshell_history_neocomplete)
  endif

  inoremap <buffer><silent><C-r> <Esc>:<C-u>Unite
        \ -buffer-name=history
        \ -default-action=append
        \ -no-split
        \ vimshell/history vimshell/external_history<CR>
  inoremap <buffer><silent><C-x><C-j> <Esc>:<C-u>Unite
        \ -buffer-name=files
        \ -default-action=cd
        \ -no-split
        \ directory_mru<CR>

  call vimshell#hook#add('chpwd', 'my_chpwd', s:vimshell_hooks.chpwd)
  call vimshell#hook#add('emptycmd', 'my_emptycmd', s:vimshell_hooks.emptycmd)
  call vimshell#hook#add('preexec', 'my_preexec', s:vimshell_hooks.preexec)
endfunction
augroup my_vimshell
  autocmd! *
  autocmd FileType vimshell call s:configure_vimshell()
augroup END

" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker
