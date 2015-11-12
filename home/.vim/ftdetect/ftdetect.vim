autocmd BufNewFile,BufRead *.txt      set filetype=markdown
autocmd BufNewFile,BufRead *.md       set filetype=markdown
autocmd BufNewFile,BufRead *.mkd      set filetype=markdown
autocmd BufNewFile,BufRead *.markdown set filetype=markdown

autocmd BufNewFile,BufRead *.t        set filetype=perl
autocmd BufNewFile,BufRead *.psgi     set filetype=perl
autocmd BufNewFile,BufRead *.tt       set filetype=tt2html

autocmd BufNewFile,BufRead *.pml      set filetype=pymol
autocmd BufNewFile,BufRead SConstruct set filetype=python

autocmd BufNewFile,BufRead *.less     set filetype=less
autocmd BufNewFile,BufRead *.sass     set filetype=sass
autocmd BufNewFile,BufRead *.scss     set filetype=scss
autocmd BufNewFile,BufRead *.ts       set filetype=typescript
autocmd BufNewFile,BufRead *.json     set filetype=json
autocmd BufNewFile,BufRead *.jsm      set filetype=javascript
autocmd BufNewFile,BufRead *.coffee   set filetype=coffeescript
autocmd BufNewFile,BufRead Cakefile   set filetype=coffeescript

autocmd BufNewFile,BufRead *.tex      set filetype=tex
autocmd BufNewFile,BufRead *.toml     set filetype=toml

" Apple Script
autocmd BufNewFile,BufRead *.scpt        set filetype=applescript
autocmd BufNewFile,BufRead *.applescript set filetype=applescript

" mdu2
autocmd BufNewFile,BufRead *.mdu2        set filetype=sh
autocmd BufNewFile,BufRead *.mdu2script  set filetype=sh
autocmd BufNewFile,BufRead skeleton.in   set filetype=fortran
autocmd BufNewFile,BufRead mm*.in        set filetype=fortran
autocmd BufNewFile,BufRead me*.in        set filetype=fortran
autocmd BufNewFile,BufRead md*.in        set filetype=fortran
autocmd BufNewFile,BufRead mdin          set filetype=fortran
autocmd BufNewFile,BufRead mdin.*        set filetype=fortran
