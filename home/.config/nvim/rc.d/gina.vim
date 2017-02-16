call gina#command#custom('log', '--opener', 'vsplit')
call gina#command#custom('commit', '-v|--verbose')

let g:gina#command#browse#extra_translation_patterns = {
      \ 'ghe.admin.h': [
      \   [
      \     '\vhttps?://(%domain)/(.{-})/(.{-})%(\.git)?$',
      \     '\vgit://(%domain)/(.{-})/(.{-})%(\.git)?$',
      \     '\vgit\@(%domain):(.{-})/(.{-})%(\.git)?$',
      \     '\vssh://git\@(%domain)/(.{-})/(.{-})%(\.git)?$',
      \   ], {
      \     '_':     'https://\1/\2/\3/blob/%c1/%pt%{#L|}ls%{-L|}le',
      \     'exact': 'https://\1/\2/\3/blob/%r1/%pt%{#L|}ls%{-L|}le',
      \     'blame': 'https://\1/\2/\3/blame/%c1/%pt%{#L|}ls%{-L|}le',
      \   },
      \ ],
      \}

function! s:gina_status() abort
  nnoremap <buffer> <C-^> :<C-u>Gina commit<CR>
endfunction

function! s:gina_commit() abort
  nnoremap <buffer> <C-^> :<C-u>Gina status<CR>
endfunction

augroup my_gina
  autocmd FileType gina-status call s:gina_status()
  autocmd FileType gina-commit call s:gina_commit()
augroup END
