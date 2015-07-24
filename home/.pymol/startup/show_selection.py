# coding=utf-8
"""
Show selection

Author:     Alisue <lambdalisue@hashnote.net>
URL:        http://hashnote.net/
License:    MIT license
Dependencies:
    chempy, colour, numpy

(C) 2015, Alisue, hashnote.net
"""
__author__ = 'Alisue <lambdalisue@hashnote.net>'
__all__ = ('show_selection',)
from pymol import cmd


def print_selection(selection):
    cmd.iterate(selection, 'print "%s-%s" % (resn, resi)')

cmd.extend('print_selection', print_selection)
