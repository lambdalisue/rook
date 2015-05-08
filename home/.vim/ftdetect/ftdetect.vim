" sander [Amber] input files are written in fortran
autocmd BufNewFile,BufRead mm*.in     setf fortran
autocmd BufNewFile,BufRead md*.in     setf fortran

autocmd BufNewFile,BufRead *.txt      setf markdown
autocmd BufNewFile,BufRead *.md       setf markdown
autocmd BufNewFile,BufRead *.mkd      setf markdown
autocmd BufNewFile,BufRead *.markdown setf markdown

autocmd BufNewFile,BufRead *.t        setf perl
autocmd BufNewFile,BufRead *.psgi     setf perl
autocmd BufNewFile,BufRead *.tt       setf tt2html

autocmd BufNewFile,BufRead *.pml      setf pymol
autocmd BufNewFile,BufRead SConstruct setf python

autocmd BufNewFile,BufRead *.less     setf less
autocmd BufNewFile,BufRead *.sass     setf sass
autocmd BufNewFile,BufRead *.scss     setf scss
autocmd BufNewFile,BufRead *.ts       setf typescript
autocmd BufNewFile,BufRead *.json     setf javascript
autocmd BufNewFile,BufRead *.coffee   setf coffeescript
autocmd BufNewFile,BufRead Cakefile   setf coffeescript

autocmd BufNewFile,BufRead *.tex      setf tex
