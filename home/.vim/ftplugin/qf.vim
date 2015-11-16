if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

" Ref:http://d.hatena.ne.jp/thinca/20130708/1373210009 
" preview with p
noremap <buffer> p <CR>zz<C-w>p

" Ctrl-n/p to preview and go
noremap <buffer> <C-n> j<CR>zz<C-w>p
noremap <buffer> <C-p> k<CR>zz<C-w>p

" remove
nnoremap <silent> <buffer> dd :<C-u>call <SID>del_entry()<CR>
nnoremap <silent> <buffer> x  :<C-u>call <SID>del_entry()<CR>
vnoremap <silent> <buffer> d  :<C-u>'<,'>call <SID>del_entry()<CR>
vnoremap <silent> <buffer> x  :<C-u>'<,'>call <SID>del_entry()<CR>

" TODO: it does not work with location list
"       `getloclist` might required to add.
function! s:del_entry() range
  let qf = getqflist()
  let history = get(w:, 'qf_history', [])
  call add(history, copy(qf))
  let w:qf_history = history
  unlet! qf[a:firstline - 1 : a:lastline - 1]
  call setqflist(qf, 'r')
  execute a:firstline
endfunction

" undo
nnoremap <silent> <buffer> u :<C-u>call <SID>undo_entry()<CR>

" TODO: it does not work with location list
"       `getloclist` might required to add.
function! s:undo_entry()
  let history = get(w:, 'qf_history', [])
  if !empty(history)
    call setqflist(remove(history, -1), 'r')
  endif
endfunction
