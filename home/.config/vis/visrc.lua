-- load standard vis module, providing parts of the Lua API
require('vis')

vis.events.win_open = function(win)
  -- enable syntax highlighting for known file types
  vis.filetype_detect(win)

  vis:command('map! normal ; :')
  vis:command('map! normal : ;')
end
