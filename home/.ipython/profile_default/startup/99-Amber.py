import os
import sys

AMBERTOOLS = os.path.join(
    os.path.dirname(os.path.dirname(os.path.dirname(__file__))),
    '.jupyter', 'python',
)

if AMBERTOOLS not in sys.path:
    sys.path.insert(0, AMBERTOOLS)
