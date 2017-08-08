" python3 plugins
call remote#host#RegisterPlugin('python3', 'C:/Users/lambd/.cache/dein/.cache/init.vim/.dein/rplugin/python3/deoplete', [
      \ {'sync': v:false, 'name': '_deoplete', 'type': 'function', 'opts': {}},
     \ ])
call remote#host#RegisterPlugin('python3', 'C:/Users/lambd/.cache/dein/repos/github.com/Shougo/denite.nvim/rplugin/python3/denite', [
      \ {'sync': v:true, 'name': '_denite_init', 'type': 'function', 'opts': {}},
      \ {'sync': v:true, 'name': '_denite_start', 'type': 'function', 'opts': {}},
      \ {'sync': v:true, 'name': '_denite_do_action', 'type': 'function', 'opts': {}},
     \ ])
call remote#host#RegisterPlugin('python3', 'C:/Users/lambd/.cache/dein/repos/github.com/lambdalisue/lista.nvim/rplugin/python3/lista', [
      \ {'sync': v:true, 'name': '_lista_resume', 'type': 'function', 'opts': {}},
      \ {'sync': v:true, 'name': '_lista_start', 'type': 'function', 'opts': {}},
     \ ])


" ruby plugins


" python plugins


