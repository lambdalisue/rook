#!/usr/bin/env python
# vim: set fileencoding=utf-8 :
#
# Author:   Alisue (lambdalisue@hashnote.net)
# URL:      http://hashnote.net/
# Date:     2013-09-20
#
# (C) 2013 hashnote.net, Alisue
#
import os.path
import shutil
import tempfile
import subprocess
from pymol import cmd
from tkFileDialog import asksaveasfilename
from tkMessageBox import showerror


def __init__(self):
    self.menuBar.addmenuitem('Plugin', 'command',
            'Save movie', 
            label = 'Save movie as',
            command=lambda s=self: saveMovieDialog(s))

def saveMovieDialog(app):
    opts = {
        'defaultextension': 'mp4',
        'filetypes': [
            ('all files', '.*'),
            ('MP4 files', '.mp4'),
            ('MPG files', '.mpg'),
        ],
        'initialfile': 'movie.mp4',
        'parent': app.root,
        'title': 'Save movie as',
    }
    filename = asksaveasfilename(**opts)
    save_movie(filename)

def save_movie(filename, delay=1, loop=1):
    """
    Save movie to a single movie file via ImageMagick

    Arguments:
        filename -- a filename of output movie file
        delay -- 0 or 1. `convert` option
        loop -- 0 or 1. `convert` option
    """
    # create temp directory
    tempdir = tempfile.mkdtemp()
    # save movie as continueous numbered png files
    cmd.mpng(os.path.join(tempdir, 'mov'))
    # wait until previous command termination
    cmd.count_frames()  # this is required to wait mpng end
    cmd.sync()
    # run ImageMagick to convert png files into a single movie file
    args = ('convert',
            '-delay', str(delay),
            '-loop', str(loop), 
            os.path.join(tempdir, 'mov*.png'),
            filename)
    exit_code = subprocess.call(args)
    if exit_code == 0:
        print u"A movie file is saved to '%s'" % filename.decode('utf8')
        # remove tempdir
        shutil.rmtree(tempdir)
    else:
        print 'ERROR: Failed to save "%s"' % filename.decode('utf8')
        print '|'
        print '| This program require "ImageMagick" and "FFMpeg". First please'
        print '| check these programs are correctly installed.'
        print '| And also, make sure that the following command works in terminal'
        print '|'
        print '|  %s' % ' '.join(args)
        print '|'
        showerror('Failed to save "%s"' % filename.decode('utf8'),
                "Internally executed program was failed."
                "See more detail on console.")

cmd.extend('save_movie', save_movie)
