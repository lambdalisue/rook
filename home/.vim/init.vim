let s:file = expand('<sfile>:p')
let s:root = fnamemodify(s:file, ':h')
let s:is_windows = has('win16') || has('win32') || has('win64')
let s:separator = s:is_windows && !&shellslash ? '\' : '/'

" Source Vim's vimrc
execute printf('source %s', fnameescape(s:root . s:separator . 'vimrc'))

tnoremap <Esc> <C-\><C-n>
tnoremap <C-w>h <C-\><C-n><C-w>h
tnoremap <C-w>j <C-\><C-n><C-w>j
tnoremap <C-w>k <C-\><C-n><C-w>k
tnoremap <C-w>l <C-\><C-n><C-w>l

" Window resize operations with <S-Arrow>
tnoremap <S-Left>  <C-\><C-n><C-w><<CR>
tnoremap <S-Right> <C-\><C-n><C-w>><CR>
tnoremap <S-Up>    <C-\><C-n><C-w>-<CR>
tnoremap <S-Down>  <C-\><C-n><C-w>+<CR>

tnoremap <C-n> <C-\><C-n>gt
tnoremap <C-p> <C-\><C-n>gT
tnoremap <C-t>t <C-\><C-n>:<C-u>tabnew<CR>
tnoremap <C-t><C-t> <C-\><C-n>:<C-u>tabnew<CR>
