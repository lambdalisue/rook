#!/usr/bin/env python
# coding=utf-8
"""

(C) 2013 hashnote.net, Alisue
"""
__author__  = 'Alisue (lambdalisue@hashnote.net)'
__version__ = '0.1.0'
__date__    = '2013-10-16'
from pymol import cmd

def trove_colorscheme():
    colors = [
        "51574a",
        "447c69",
        "74c493",
        "8e8c6d",
        "e4bf80",
        "e9d78e",
        "e2975d",
        "f19670",
        "e16552",
        "c94a53",
        "be5168",
        "a34974",
        "993767",
        "65387d",
        "4e2472",
        "9163b6",
        "e279a3",
        "e0598b",
        "7c9fb0",
        "5698c4",
        "9abf88"
    ]
    def html2rgb(html):
        r = int(html[:2], 16)
        g = int(html[2:4], 16)
        b = int(html[4:], 16)
        return r, g, b
    for i, color in enumerate(colors):
        r, g, b = html2rgb(color)
        cmd.set_color("trove%d" % (i+1), [
            r / 255.0,
            g / 255.0,
            b / 255.0,
        ])

if __name__ == 'pymol':
    trove_colorscheme()


