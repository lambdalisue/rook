import os
import sys
import functools

def repeat(n, fn, x):
    if n == 1:
        return fn(x)
    else:
        return fn(repeat(fn, n-1, x))

AMBERTOOLS = os.path.join(
    repeat(4, os.path.dirname, __file__),
    '.jupyter', 'python',
)

if AMBERTOOLS not in sys.path:
    sys.path.insert(0, AMBERTOOLS)
