" sander [Amber] input files are written in fortran
autocmd BufNewFile,BufRead mm*.in     set filetype=fortran
autocmd BufNewFile,BufRead md*.in     set filetype=fortran

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
autocmd BufNewFile,BufRead *.json     set filetype=javascript
autocmd BufNewFile,BufRead *.coffee   set filetype=coffeescript
autocmd BufNewFile,BufRead Cakefile   set filetype=coffeescript

autocmd BufNewFile,BufRead *.tex      set filetype=tex
autocmd BufNewFile,BufRead *.applescript *.scpt set filetype=applescript
