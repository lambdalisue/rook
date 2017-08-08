call gina#custom#command#alias('branch', 'br')
call gina#custom#command#option('br', '-v', 'v')
call gina#custom#command#option('br', '--all')
call gina#custom#command#option(
      \ 'commit', '-v|--verbose'
      \)
call gina#custom#command#option(
      \ '/\%(status\|commit\)',
      \ '-u|--untracked-files'
      \)
call gina#custom#command#option(
      \ '/\%(status\|changes\)',
      \ '--ignore-submodules'
      \)
call gina#custom#command#option(
      \ 'status',
      \ '-b|--branch'
      \)
call gina#custom#command#option(
      \ 'status',
      \ '-s|--short'
      \)
call gina#custom#command#option(
      \ '/\%(status\|branch\|changes\|tag\)',
      \ '--opener',
      \ 'topleft 10split',
      \)
call gina#custom#command#option(
      \ '/\%(status\|branch\|changes\|tag\)',
      \ '--group',
      \ 'gina-top10',
      \)
call gina#custom#command#option(
      \ '/\%(ls\|grep\)',
      \ '--opener',
      \ 'botright 30split',
      \)
call gina#custom#command#option(
      \ '/\%(ls\|grep\)',
      \ '--group',
      \ 'gina-bot30',
      \)
call gina#custom#command#option(
      \ '/\%(log\|reflog\)',
      \ '--opener',
      \ 'topleft 80vsplit',
      \)
call gina#custom#command#option(
      \ '/\%(log\|reflog\)',
      \ '--group',
      \ 'gina-left80',
      \)
call gina#custom#command#option(
      \ '/\%(commit\)',
      \ '--opener',
      \ 'botright 80vsplit',
      \)

call gina#custom#action#alias(
      \ 'branch', 'track',
      \ 'checkout:track'
      \)
call gina#custom#action#alias(
      \ 'branch', 'merge',
      \ 'commit:merge'
      \)
call gina#custom#action#alias(
      \ 'branch', 'rebase',
      \ 'commit:rebase'
      \)

call gina#custom#mapping#nmap(
      \ 'branch', 'g<CR>',
      \ '<Plug>(gina-commit-checkout-track)'
      \)
call gina#custom#mapping#nmap(
      \ 'status', '<C-6>',
      \ ':<C-u>Gina commit<CR>',
      \ {'noremap': 1, 'silent': 1}
      \)
call gina#custom#mapping#nmap(
      \ 'commit', '<C-6>',
      \ ':<C-u>Gina status<CR>',
      \ {'noremap': 1, 'silent': 1}
      \)

call gina#custom#action#alias(
      \ '/\%(blame\|log\|reflog\)',
      \ 'preview',
      \ 'topleft show:commit:preview',
      \)
call gina#custom#mapping#nmap(
      \ '/\%(blame\|log\|reflog\)',
      \ 'p',
      \ ':<C-u>call gina#action#call(''preview'')<CR>',
      \ {'noremap': 1, 'silent': 1}
      \)

call gina#custom#execute(
      \ '/\%(status\|branch\|ls\|grep\|changes\|tag\)',
      \ 'setlocal winfixheight',
      \)
call gina#custom#execute(
      \ '/\%(log\|reflog\)',
      \ 'setlocal winfixwidth',
      \)
call gina#custom#execute(
      \ '/\%(ls\|log\|reflog\|grep\)',
      \ 'setlocal noautoread',
      \)

" Echo chunk info with j/k
call gina#custom#mapping#nmap(
      \ 'blame', 'j',
      \ 'j<Plug>(gina-blame-echo)'
      \)
call gina#custom#mapping#nmap(
      \ 'blame', 'k',
      \ 'k<Plug>(gina-blame-echo)'
      \)
