scriptencoding utf-8

augroup MyAutoCmdForDein
  autocmd! *
augroup END

function! s:is_git_available()
  if !executable('git')
    return 0
  endif
  if dein#is_sourced('vim-gita')
    return gita#is_enabled()
  elseif dein#is_sourced('vimproc')
    call vimproc#system('git rev-parse')
    return (vimproc#get_last_status() == 0) ? 1 : 0
  else
    call system('git rev-parse')
    return (v:shell_error == 0) ? 1 : 0
  endif
endfunction

function! s:register_on_source_hook(...) abort
  let fname = get(a:000, 0, printf(
        \ 's:%s_on_source',
        \ substitute(g:dein#name, '[-.]', '_', 'g'),
        \))
  execute printf(
        \ 'autocmd MyAutoCmdForDein User dein#source#%s call %s()',
        \ g:dein#name, fname,
        \)
endfunction

" Fundemental ----------------------------------------------------------------
if dein#tap('vim-template') " {{{
  function! s:template_call() abort
    " evaluate {CODE} in <%={CODE}=> and replace
    silent %s/<%=\(.\{-}\)%>/\=eval(submatch(1))/ge
    " move the cursor into <+CURSOR+>
    if search('<+CURSOR+>', 'cw')
      silent execute 'normal! "_da>'
    endif
  endfunction
  autocmd MyAutoCmdForDein User plugin-template-loaded call s:template_call()
endif " }}}

if dein#tap('vim-findent') " {{{
  augroup findent
    autocmd!
    autocmd FileType json,javascript    Findent --no-warnings
    autocmd FileType typescript         Findent --no-warnings
    autocmd FileType coffeescript       Findent --no-warnings
    autocmd FileType css,scss,sass,less Findent --no-warnings
    autocmd FileType xml,html           Findent --no-warnings
    autocmd FileType perl,python,ruby   Findent --no-warnings
  augroup END
endif " }}}

if dein#tap('vim-foldround') " {{{
  function! s:vim_foldround_on_source() abort
    call foldround#register('\.vim$', [
          \ 'syntax', 'marker',
          \])
    call foldround#register('\.vim/.*\.vim$', [
          \ 'syntax', 'marker',
          \])
    call foldround#register('[./]g\?vimrc$', [
          \ 'syntax', 'marker',
          \])
  endfunction
  call s:register_on_source_hook()
endif " }}}

if dein#tap('vim-easymotion') " {{{
  function! s:incsearch_config(...) abort
    return incsearch#util#deepextend(deepcopy({
          \ 'modules': [incsearch#config#easymotion#module({'overwin': 1})],
          \ 'keymap': {
          \   "\<CR>": '<Over>(easymotion)',
          \ },
          \ 'is_expr': 0,
          \}), get(a:, 1, {}))
  endfunction
  let g:EasyMotion_do_mapping = 0
  nnoremap <nowait><silent><expr> s incsearch#go(<SID>incsearch_config())
endif " }}}


" Textobj --------------------------------------------------------------------
if dein#tap('vim-textobj-python') " {{{
  function! s:vim_textobj_python_on_source() abort
    function! s:textobj_python_settings() abort
      xmap <buffer> aF <Plug>(textobj-python-function-a)
      omap <buffer> iF <Plug>(textobj-python-function-i)
      xmap <buffer> aC <Plug>(textobj-python-class-a)
      omap <buffer> iC <Plug>(textobj-python-class-i)
    endfunction
    autocmd MyAutoCmdForDein FileType python call s:textobj_python_settings()
  endfunction
  call s:register_on_source_hook()
endif " }}}


" Interfaces -----------------------------------------------------------------
if dein#tap('unite.vim') " {{{
  nnoremap <Plug>(my-unite) <Nop>
  nmap <Space> <Plug>(my-unite)
  vmap <Space> <Plug>(my-unite)

  nnoremap <silent> <Plug>(my-unite)<Space>
        \ :<C-u>UniteResume -no-start-insert<CR>
  nnoremap <silent> <Plug>(my-unite)w
        \ :<C-u>Unite buffer<CR>
  nnoremap <silent> <Plug>(my-unite)k
        \ :<C-u>Unite bookmark<CR>
  nnoremap <silent> <Plug>(my-unite)l :<C-u>Unite line
        \ -buffer-name=search<CR>
  nnoremap <silent> <Plug>(my-unite)h :<C-u>Unite help
        \ -buffer-name=search<CR>
  nnoremap <silent> <Plug>(my-unite)mp
        \ :<C-u>Unite map
        \ -buffer-name=search<CR>
  vnoremap <silent> <Plug>(my-unite)l
        \ :<C-u>UniteWithCursorWord line
        \ -buffer-name=search<CR>
  vnoremap <silent> <Plug>(my-unite)h
        \ :<C-u>UniteWithCursorWord help
        \ -buffer-name=search<CR>

  " unite-menu
  nnoremap <silent> <Plug>(my-unite)s
        \ :<C-u>Unite menu:shortcut<CR>

  " unite-file
  nnoremap <Plug>(my-unite-file) <Nop>
  nmap <Plug>(my-unite)f <Plug>(my-unite-file)
  nnoremap <silent> <Plug>(my-unite-file)f
        \ :<C-u>call <SID>unite_smart_file()<CR>
  nnoremap <silent> <Plug>(my-unite-file)i
        \ :<C-u>Unite file<CR>
  nnoremap <silent> <Plug>(my-unite-file)m
        \ :<C-u>Unite file_mru<CR>
  nnoremap <silent> <Plug>(my-unite-file)r
        \ :<C-u>Unite file_rec/async<CR>
  nnoremap <silent> <Plug>(my-unite-file)g
        \ :<C-u>Unite file_rec/git<CR>
  function! s:unite_smart_file()
    if s:is_git_available()
      Unite file_rec/git
    else
      Unite file_rec/async
    endif
  endfunction

  " unite-directory
  nnoremap <Plug>(my-unite-directory) <Nop>
  nmap <Plug>(my-unite)d <Plug>(my-unite-directory)
  nnoremap <silent> <Plug>(my-unite-directory)d
        \ :<C-u>Unite directory_rec/async<CR>
  nnoremap <silent> <Plug>(my-unite-directory)i
        \ :<C-u>Unite directory<CR>
  nnoremap <silent> <Plug>(my-unite-directory)m
        \ :<C-u>Unite directory_mru<CR>
  nnoremap <silent> <Plug>(my-unite-directory)r
        \ :<C-u>Unite directory_rec/async<CR>

  " unite-qf
  nnoremap <Plug>(my-unite-qf) <Nop>
  nmap <Plug>(my-unite)q <Plug>(my-unite-qf)
  nnoremap <silent> <Plug>(my-unite-qf)q
        \ :<C-u>Unite quickfix location_list
        \ -buffer-name=search<CR>
  nnoremap <silent> <Plug>(my-unite-qf)f
        \ :<C-u>Unite quickfix
        \ -buffer-name=search<CR>
  nnoremap <silent> <Plug>(my-unite-qf)l
        \ :<C-u>Unite location_list
        \ -buffer-name=search<CR>

  " unite-grep
  nnoremap <Plug>(my-unite-grep) <Nop>
  nmap <Plug>(my-unite)g <Plug>(my-unite-grep)
  vmap <Plug>(my-unite)g <Plug>(my-unite-grep)
  nnoremap <silent> <Plug>(my-unite-grep)*
        \ :<C-u>UniteWithCursorWord grep:.
        \ -buffer-name=search
        \ -no-empty<CR>
  vnoremap <silent> <Plug>(my-unite-grep)*
        \ :UniteWithCursorWord grep:.
        \ -buffer-name=search
        \ -no-empty<CR>
  nnoremap <silent> <Plug>(my-unite-grep)g
        \ :<C-u>Unite grep:.
        \ -buffer-name=search
        \ -no-empty<CR>
  vnoremap <silent> <Plug>(my-unite-grep)g
        \ :Unite grep:.
        \ -buffer-name=search
        \ -no-empty<CR>
  nnoremap <silent> <Plug>(my-unite-grep)i
        \ :<C-u>Unite grep/git:/
        \ -buffer-name=search
        \ -no-empty<CR>
  vnoremap <silent> <Plug>(my-unite-grep)i
        \ :Unite grep/git:/
        \ -buffer-name=search
        \ -no-empty<CR>

  " unite-git
  nnoremap <Plug>(my-unite-git) <Nop>
  nmap <Plug>(my-unite)i <Plug>(my-unite-git)
  nnoremap <silent> <Plug>(my-unite-git)i
        \ :<C-u>Unite giti/branch_recent<CR>
  nnoremap <silent> <Plug>(my-unite-git)b
        \ :<C-u>Unite giti/branch_recent giti/branch_all<CR>
  nnoremap <silent> <Plug>(my-unite-git)r
        \ :<C-u>Unite giti/remote<CR>

  " unite-gista
  nnoremap <silent> <Plug>(my-unite-git)t
        \ :<C-u>Unite gista:lambdalisue<CR>

  " unite-ref
  nnoremap <Plug>(my-unite-ref) <Nop>
  nmap <Plug>(my-unite)r <Plug>(my-unite-ref)
  nnoremap <silent> <Plug>(my-unite-ref)r
              \ :<C-u>call <SID>unite_smart_ref()<CR>
  nnoremap <silent> <Plug>(my-unite-ref)p
              \ :<C-u>Unite ref/pydoc<CR>
  nnoremap <silent> <Plug>(my-unite-ref)l
              \ :<C-u>Unite perldoc<CR>
  nnoremap <silent> <Plug>(my-unite-ref)m
              \ :<C-u>Unite ref/man<CR>
  nnoremap <silent> <Plug>(my-unite-ref)j
              \ :<C-u>Unite ref/javascript<CR>
  nnoremap <silent> <Plug>(my-unite-ref)q
              \ :<C-u>Unite ref/jquery<CR>
  nnoremap <silent> <Plug>(my-unite-ref)k
              \ :<C-u>Unite ref/kotobank<CR>
  nnoremap <silent> <Plug>(my-unite-ref)w
              \ :<C-u>Unite ref/wikipedia<CR>
  function! s:unite_smart_ref()
    if &filetype =~# 'perl'
      Unite perldoc
    elseif &filetype =~# 'python'
      Unite ref/pydoc
    elseif &filetype =~# 'ruby'
      Unite ref/refe
    elseif &filetype =~# 'javascript'
      Unite ref/javascript
    elseif &filetype =~# 'vim'
      Unite help
    else
      Unite ref/man
    endif
  endfunction

  " unite-linephrase
  nnoremap <silent> <Plug>(my-unite)p
        \ :<C-u>Unite linephrase
        \ -no-quit -keep-focus -no-start-insert
        \ -buffer-name=search<CR>

  " unite-outline
  nnoremap <silent> <Leader>o
        \ :<C-u>Unite outline
        \ -no-quit -keep-focus -no-start-insert
        \ -vertical -direction=botright -winwidth=30<CR>

  " vim-bookmarks
  nnoremap <silent> <Plug>(my-unite)mm
        \ :<C-u>Unite vim_bookmarks
        \ -no-quit -keep-focus -no-start-insert
        \ -buffer-name=search<CR>

endif " }}}

if dein#tap('vim-ref') " {{{
  function! s:vim_ref_on_source() abort
    let g:ref_open = 'vsplit'
    function! s:ref_configure() abort
      nmap <buffer><silent> <C-p> <Plug>(ref-back)
      nmap <buffer><silent> <C-n> <Plug>(ref-forward)
    endfunction
    autocmd MyAutoCmdForDein FileType ref call s:ref_configure()
  endfunction
  call s:register_on_source_hook()
endif " }}}


" Version control system -----------------------------------------------------
if dein#tap('agit.vim') " {{{
  function! s:agit_vim_on_source() abort
    " add extra key-mappings
    function! s:my_agit_setting() abort
      nmap <buffer> ch <Plug>(agit-git-cherry-pick)
      nmap <buffer> Rv <Plug>(agit-git-revert)
    endfunction
    autocmd MyAutoCmdForDein FileType agit call s:my_agit_setting()
  endfunction
  call s:register_on_source_hook()
endif " }}}


" Filetype specific ----------------------------------------------------------
if dein#tap('LaTeX-Box') " {{{
  function! s:LaTeX_Box_on_source() abort
    let g:LatexBox_latexmk_async = 1
    let g:LatexBox_latexmk_preview_continuously = 1
    let g:LatexBox_latexmk_options = '-pdfdvi'
    let g:LatexBox_build_dir = 'build'
    let g:LatexBox_Folding = 1
    let g:LatexBox_quickfix = 2
    let g:LatexBox_ignore_warnings = [
          \ 'Underfull', 'Overfull', 'specifier changed to',
          \ 'Module luatexbase-mcb warning: several functions in ',
          \ 'xparse/redefine-command',
          \ 'luatexja-preset warning: "scale"',
          \ 'Unsupported document class',
          \ '\setcatcoderange is deprecated',
          \ 'LaTeX Warning: You have requested document class',
          \ 'LaTeX Font Warning: Font shape',
          \ 'Package typearea Warning: Bad type area settings!',
          \ 'LaTeX Font Warning: Some font shapes were not available, defaults substituted.'
          \ ]
    " neocomplete should not used for tex
    let g:neocomplete#force_omni_input_patterns =
          \ get(g:, 'neocomplete#force_omni_input_patterns', {})
    let g:neocomplete#force_omni_input_patterns.tex =
          \ '\v(\\\a*(subref|ref|textcite|autocite|cite)\a*\{([^}]*,)?|\$)'

    function! s:latexbox_configure() abort
      imap <buffer> [[     \begin{
      imap <buffer> ]]     <Plug>LatexCloseCurEnv
      nmap <buffer> <F5>   <Plug>LatexChangeEnv
      vmap <buffer> <F7>   <Plug>LatexWrapSelection
      vmap <buffer> <S-F7> <Plug>LatexEnvWrapSelection
      imap <buffer> ((     \eqref{
    endfunction
    autocmd MyAutoCmdForDein FileType tex,latex,plaintex call s:latexbox_configure()
  endfunction
  call s:register_on_source_hook()
endif " }}}

if dein#tap('jedi-vim') " {{{
  function! s:jedi_vim_on_source() abort
    function! s:jedi_vim_configure() abort
      setlocal omnifunc=jedi#completions
      nmap <buffer> <LocalLeader>g <Plug>(jedi-goto-assignments)
      nmap <buffer> <LocalLeader>d <Plug>(jedi-goto-definitions)
      nmap <buffer> <LocalLeader>R <Plug>(jedi-rename)
      nmap <buffer> <LocalLeader>n <Plug>(jedi-usage)
      nmap <buffer> K <Plug>(jedi-show-documentation)
    endfunction
    autocmd MyAutoCmdForDein FileType python call s:jedi_vim_configure()
  endfunction
  call s:register_on_source_hook()

  " jedi does not provide <Plug>(jedi-X) mappings
  nnoremap <silent> <Plug>(jedi-goto-assignments)
        \ :<C-u>call jedi#goto_assignments()<CR>
  nnoremap <silent> <Plug>(jedi-goto-definitions)
        \ :<C-u>call jedi#goto_definitions()<CR>
  nnoremap <silent> <Plug>(jedi-show-documentation)
        \ :<C-u>call jedi#show_documentation()<CR>
  nnoremap <silent> <Plug>(jedi-rename)
        \ :<C-u>call jedi#rename()<CR>
  nnoremap <silent> <Plug>(jedi-usages)
        \ :<C-u>call jedi#usages()<CR>
endif " }}}

if dein#tap('vim-pyenv') " {{{
  function! s:vim_pyenv_on_source() abort
    if jedi#init_python()
      function! s:jedi_auto_force_py_version() abort
        let major_version = pyenv#python#get_internal_major_version()
        call jedi#force_py_version(major_version)
      endfunction
      autocmd MyAutoCmdForDein User vim-pyenv-activate-post   call s:jedi_auto_force_py_version()
      autocmd MyAutoCmdForDein User vim-pyenv-deactivate-post call s:jedi_auto_force_py_version()
    endif
  endfunction
  call s:register_on_source_hook()
endif " }}}

if dein#tap('tsuquyomi') " {{{
  function! s:tsuquyomi_on_source() abort
    function! s:tsuquyomi_configure() abort
      nmap <buffer> <LocalLeader>d <Plug>(TsuquyomiDefinition)
      nmap <buffer> <LocalLeader>b <Plug>(TsuquyomiGoBack)
      nmap <buffer> <LocalLeader>r <Plug>(TsuquyomiReferences)
      nmap <buffer> <LocalLeader>R <Plug>(TsuquyomiRenameSymbolC)
      if exists('&ballooneval')
        setlocal ballooneval
        setlocal balloonexpr=tsuquyomi#balloonexpr()
      endif
    endfunction
    autocmd MyAutoCmdForDein FileType typescript call s:tsuquyomi_configure()
  endfunction
  call s:register_on_source_hook()
endif " }}}

" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker
