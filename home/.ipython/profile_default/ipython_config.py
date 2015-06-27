c = get_config()

c.InteractiveShellApp.exec_lines = [
    'import numpy as np',
    'import scipy as sp',
    'import pandas as pd',
    'import matplotlib.pyplot as pl',
]
c.InteractiveShell.autoindent = True
c.InteractiveShell.editor = 'vim'

# Automatically enable %matplotlib inline
c.InteractiveShellApp.matplotlib = 'inline'
