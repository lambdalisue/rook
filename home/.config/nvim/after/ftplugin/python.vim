" PEP8 Indent rules

setl tabstop=8        " width of TAB should be 8 characters
setl softtabstop=4    " 4 continuous spaces are assumed as Soft tab
setl shiftwidth=4     " width of Indent
setl smarttab         " use 'shiftwidth' and 'softtabstop' for indentation
setl expandtab        " use continuous spaces as TAB

" Each lines should be shorter than 80 characters
setl textwidth=79
if exists('&colorcolumn')
  setl colorcolumn=+1
endif

" Indent rules should be overwritten by plugin
" https://github.com/hynek/vim-python-pep8-indent
"setl autoindent           " copy inent leven from previous line
"setl nosmartindent        " do not use smartindent, indent after # will be suck
"setl cindent              " use cindent instead of smartindent and autoindent
"setl cinwords=if,elif,else,for,while,try,except,finally,def,class,with

" Folding should follow indent rules
"setl foldmethod=indent


function! s:open_pypi(word) abort
  let baseurl = 'https://pypi.python.org/pypi/%s'
  call openbrowser#open(printf(baseurl, a:word))
endfunction

nnoremap <buffer><silent> <Plug>(my-python-pypi) :<C-u>call <SID>open_pypi(expand('<cWORD>'))<CR>
nmap <buffer> gK <Plug>(my-python-pypi)
