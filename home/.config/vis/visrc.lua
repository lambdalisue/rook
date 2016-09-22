-- load standard vis module, providing parts of the Lua API
require('vis')

vis.events.win_open = function(win)
	-- enable syntax highlighting for known file types
	vis.filetype_detect(win)

  	vis:command('set tabwidth 4')
  	vis:command('set expandtab on')
  	vis:command('set autoindent on')
  	vis:command('set cursorline on')
  	vis:command('set colorcolumn 80')

	vis:command('map! normal ; :')
	vis:command('map! insert <C-a> <cursor-line-start>')
	vis:command('map! insert <C-e> <cursor-line-end>')
	vis:command('map! insert <C-f> <cursor-char-prev>')
	vis:command('map! insert <C-b> <cursor-char-next>')
end
