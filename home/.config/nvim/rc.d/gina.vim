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

call gina#custom#command#option('log', '--opener', 'vsplit')
call gina#custom#command#option('branch', '-v', 'v')
call gina#custom#command#option('commit', '-v|--verbose')
call gina#custom#command#option('commit', '-u|--untracked-files')
call gina#custom#command#option('status', '-u|--untracked-files')
call gina#custom#command#option('status', '--ignore-submodules')
call gina#custom#command#option('changes', '--ignore-submodules')
call gina#custom#command#alias('status', 'st')

call gina#custom#action#alias('branch', 'track', 'checkout:track')
call gina#custom#mapping#nmap('branch', 'g<CR>', '<Plug>(gina-branch-checkout-track)')
call gina#custom#mapping#nmap('status', '<C-^>', ':<C-u>Gina commit<CR>')
call gina#custom#mapping#nmap('commit', '<C-^>', ':<C-u>Gina status<CR>')
