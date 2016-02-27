" define <Leader> and <LocalLeader>
let g:mapleader = ';'
let g:maplocalleader = ','

" remove any existing keymap for leader and localleader
noremap <Leader> <Nop>
noremap <LocalLeader> <Nop>

" disable dengerous mappings (ZZ: save and close, ZQ close)
noremap <MiddleMouse>   <Nop>
noremap <2-MiddleMouse> <Nop>
noremap <3-MiddleMouse> <Nop>
noremap <4-MiddleMouse> <Nop>
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>

" disable EX mode and assign it into gq
" gq{motion} : format the lines that {motion} moves over
nnoremap Q gq

" remove highlight with pressing ESC twice
nnoremap <silent> <Esc><Esc> :<C-u>nohlsearch<CR>

" Select last paste (like gv)
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" Improve cursor operation
nnoremap <expr> j v:count == 0 ? 'gj' : 'j'
nnoremap <expr> k v:count == 0 ? 'gk' : 'k'
nnoremap <expr> gj v:count == 0 ? 'j' : 'gj'
nnoremap <expr> gk v:count == 0 ? 'k' : 'gk'

xnoremap <silent><expr> <C-k> mode() ==# 'V'
      \ ? ':<C-u>execute printf("move -1-%d", v:count1)<CR>gv'
      \ : '<C-k>'
xnoremap <silent><expr> <C-j> mode() ==# 'V'
      \ ? ':<C-u>execute printf("move +%d", v:count1)<CR>gv'
      \ : '<C-k>'

" Emacs like binding in Insert mode
inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-f> <C-o>w
inoremap <C-b> <C-o>b
inoremap <C-d> <C-o>x

" Y to yank the end of line
nnoremap Y y$

" vv to select the line, like yy, dd
nnoremap vv 0v$

" <C-p> to paste from 0 register
nnoremap <Leader>p "0p

" Better <C-n>/<C-p> in command mode
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <Up> <C-p>
cnoremap <Down> <C-n>

" simple window resize navigation
nnoremap <S-Left>  <C-w><<CR>
nnoremap <S-Right> <C-w>><CR>
nnoremap <S-Up>    <C-w>-<CR>
nnoremap <S-Down>  <C-w>+<CR>

" simple window navigation
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

" tag navigation
nnoremap [t  :<C-u>tprevious<CR>
nnoremap ]t  :<C-u>tnext<CR>
nnoremap g[t :<C-u>tfirst<CR>
nnoremap g]t :<C-u>tlast<CR>

" quickfix navigation
nnoremap [q  :<C-u>cprevious<CR>
nnoremap ]q  :<C-u>cnext<CR>
nnoremap g[q :<C-u>cfirst<CR>
nnoremap g]q :<C-u>clast<CR>
nnoremap [l  :<C-u>lprevious<CR>
nnoremap ]l  :<C-u>lnext<CR>
nnoremap g[l :<C-u>lfirst<CR>
nnoremap g]l :<C-u>llast<CR>

" file navigation
nnoremap {f  :<C-u>previous<CR>
nnoremap }f  :<C-u>next<CR>
nnoremap g{f :<C-u>first<CR>
nnoremap g}f :<C-u>last<CR>

" tab operation (make similar mapping with window operation)
" ref.
function! s:tab_quit() abort
  if tabpagenr('$') == 1
    quit
  else
    tabclose
  endif
endfunction
nnoremap <silent> <Plug>(my-tab-new)  :<C-u>tabnew<CR>
nnoremap <silent> <Plug>(my-tab-quit) :<C-u>call <SID>tab_quit()<CR>
nnoremap <silent> <Plug>(my-tab-next) :<C-u>tabnext<CR>
nnoremap <silent> <Plug>(my-tab-prev) :<C-u>tabprevious<CR>
nmap <C-n> <Plug>(my-tab-next)
nmap <C-p> <Plug>(my-tab-prev)
nmap <C-t>t <Plug>(my-tab-new)
nmap <C-t><C-t> <Plug>(my-tab-new)
nmap <C-t>q <Plug>(my-tab-quit)
nmap <C-t><C-q> <Plug>(my-tab-quit)

" switch options
nnoremap <Plug>(my-switch) <Nop>
nmap <Leader>s <Plug>(my-switch)
nnoremap <silent> <Plug>(my-switch)s :<C-u>setl spell! spell?<CR>
nnoremap <silent> <Plug>(my-switch)l :<C-u>setl list! list?<CR>
nnoremap <silent> <Plug>(my-switch)t :<C-u>setl expandtab! expandtab?<CR>
nnoremap <silent> <Plug>(my-switch)w :<C-u>setl wrap! wrap?<CR>
nnoremap <silent> <Plug>(my-switch)p :<C-u>setl paste! paste?<CR>
nnoremap <silent> <Plug>(my-switch)b :<C-u>setl scrollbind! scrollbind?<CR>
nnoremap <silent> <Plug>(my-switch)y :<C-u>call <SID>toggle_syntax()<CR>
function! s:toggle_syntax() abort
  if exists('g:syntax_on')
    syntax off
    redraw
    echo 'syntax off'
  else
    syntax on
    redraw
    echo 'syntax on'
  endif
endfunction

" alias for :e ++enc= | :e ++ff=
cnoreabbrev ++u ++enc=utf8
cnoreabbrev ++s ++enc=cp932
cnoreabbrev ++e ++enc=euc-jp
cnoreabbrev ++x ++ff=unix
cnoreabbrev ++d ++ff=dos
cnoreabbrev ++m ++ff=mac

" Allow misspellings
cnoreabbrev Wq :wq
cnoreabbrev qw :wq
cnoreabbrev Qa :qa
cnoreabbrev q: :q

" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker
