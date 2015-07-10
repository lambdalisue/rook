c = get_config()

c.InteractiveShellApp.exec_lines = []
c.InteractiveShell.autoindent = True
c.InteractiveShell.editor = 'vim'

# Automatically enable %matplotlib inline
c.InteractiveShellApp.matplotlib = 'inline'
