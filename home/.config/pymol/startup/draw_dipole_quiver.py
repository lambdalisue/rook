# coding=utf-8
"""
Draw water dipole vectors written in Amber 14 GIST out file in PyMOL.

GistID: a4731297906a50880d55
Author:     Alisue <lambdalisue@hashnote.net>
URL:        http://hashnote.net/
License:    MIT license
Dependencies:
    draw_quiver, chempy, colour, numpy

(C) 2014, Alisue, hashnote.net
"""
__author__ = 'Alisue <lambdalisue@hashnote.net>'
__all__ = ('draw_gist_dipole_quiver',)
import numpy as np
from pymol import cmd
from .draw_quiver import (draw_quiver, _draw_quiver)


def parse_gist(fname):
    """
    Parse Amber 14 GIST out data and return 3D Vector map
    """
    usecols = (
        1,    # x coordinate of the center of the voxel (A)
        2,    # y coordinate of the center of the voxel (A)
        3,    # z coordinate of the center of the voxel (A)
        15,   # x-component of the mean water dipole moment density (Debye/A^3)
        16,   # y-component of the mean water dipole moment density (Debye/A^3)
        17,   # z-component of the mean water dipole moment density (Debye/A^3)
    )
    data = np.loadtxt(
        fname,
        skiprows=2,   # GIST Output contains header lines
        usecols=usecols,
    )
    return data


def draw_gist_dipole_quiver(filename, name=None, prefix='quiver',
                            color=(0.5, 0.5, 0.5), scale=1.0, radius=0.02,
                            hlength=None, hradius=None,
                            min_length=None, max_length=None,
                            length=None, relative=False,
                            verbose=0, validation=False):
    """
    Create quiver CGO object (meshed vectors) which indicate the water dipole
    written in Amber 14 GIST out file

    Args:
        filename (string): An output file of Amber 14 GIST command
        name (None or string): An name of the CGO object. If it is not
            specified, continuous numbered name with the specified prefix
            will be used.
        prefix (string): A prefix string which is used to determine the CGO
            object name if no name is specified. The default value is 'quiver'.
        color (list): A color color list (r, g, b). The default value is
            (0.5, 0.5, 0.5)
        scale (float): A scale of each vector. It is used only for
            visualization. The default value is 1.0.
        radius (float): A radius of each vector line. The default value is
            0.02.
        hlength (None or float): A hat length of each vector
        hradius (None or float): A hat radius of each vector
        min_length (None or float): A minimum vector length. All vectors
            shorter than this length will not be displayed. Please be aware
            that the scale factor does NOT influence this filteration.
        max_length (None or float): A maximum vector length. All vectors
            longer than this length will not be displayed. Please be aware
            that the scale factor does NOT influence this filteration.
        length (None or float): A fixed length of vector. If this value
            is specified, the length of all vectors are fixed to this value.
        relative (boolean): If this is True, length of vector will be
            transformed to relative length (min=0, max=1)
    """
    # parse GIST output file and create 3D Vector map
    vectors = parse_gist(filename)
    return draw_quiver(
        vectors,
        name=name, prefix=prefix,
        color=color, scale=scale, radius=radius,
        hlength=hlength, hradius=hradius,
        min_length=min_length, max_length=max_length,
        length=length, relative=relative,
        verbose=verbose,
        validation=validation,
    )


def _draw_gist_dipole_quiver(filename, **kwargs):
    """
    Create quiver CGO object (meshed vectors) which indicate the water dipole
    written in Amber 14 GIST out file

    Usage:
        draw_gist_dipole_quiver <filename>
        draw_gist_dipole_quiver <filename>, [options]

    Args:
        filename (string): An output file of Amber 14 GIST command
        n, name (None or string): An name of the CGO object. If it is not
            specified, continuous numbered name with the specified prefix
            will be used.
        p, prefix (string): A prefix string which is used to determine the CGO
            object name if no name is specified. The default value is 'quiver'.
        s, scale (float): A scale of each vector. It is used only for
            visualization. The default value is 1.0.
        c, color (list): A color color list (r, g, b). The default value is
            (0.5, 0.5, 0.5)
        r, radius (float): A radius of each vector line. The default value is
            0.02.
        hlength (None or float): A hat length of each vector
        hradius (None or float): A hat radius of each vector
        min, min_length (None or float): A minimum vector length. All vectors
            shorter than this length will not be displayed. Please be aware
            that the scale factor does NOT influence this filteration.
        max, max_length (None or float): A maximum vector length. All vectors
            longer than this length will not be displayed. Please be aware
            that the scale factor does NOT influence this filteration.
        length (None or float): A fixed length of vector. If this value
            is specified, the length of all vectors are fixed to this value.
        relative (boolean): If this is True, length of vector will be
            transformed to relative length (min=0, max=1)
    """
    # parse GIST output file and create 3D Vector map
    vectors = parse_gist(filename)
    return _draw_quiver(vectors, **kwargs)


# register the command
cmd.extend('draw_gist_dipole_quiver', _draw_gist_dipole_quiver)
