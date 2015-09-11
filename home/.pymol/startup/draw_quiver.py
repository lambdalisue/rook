# coding=utf-8
"""
Do 3D quiver plot (plot meshed vectors) in PyMOL.


GistID: 09791631ee4bde6dbd6a
Author:     Alisue <lambdalisue@hashnote.net>
URL:        http://hashnote.net/
License:    MIT license
Dependencies:
    chempy, colour, numpy

(C) 2014, Alisue, hashnote.net
"""
__author__ = 'Alisue <lambdalisue@hashnote.net>'
__all__ = ('draw_quiver',)
import re
import itertools
import colour
import numpy as np
from pymol import cmd
from pymol import cgo
from chempy import cpv


# Compiled Graphics Objects ---------------------------------------------------
def line(p1, p2, radius, color):
    """
    Create a line compiled graphic object from two geometrical points

    Args:
        p1 (list): A coordinate vector (x, y, z) of the start point
        p2 (list): A coordinate vector (x, y, z) of the end point
        radius (float): A radious of the line
        color (list): A color color list (r, g, b)
    """
    x1, y1, z1 = map(float, p1)
    x2, y2, z2 = map(float, p2)
    r1, g1, b1 = map(float, color)
    r2, g2, b2 = map(float, color)
    radius = float(radius)
    # create a line object (cylinder object)
    return [
        cgo.CYLINDER,
        x1, y1, z1,
        x2, y2, z2,
        radius,
        r1, g1, b1,
        r2, g2, b2
    ]


def cone(p1, p2, radius, color):
    """
    Create a cone compild graphic object from two geometrical points

    Args
        p1 (list): A coordinate vector (x, y, z) of the top point
        p2 (list): A coordinate vector (x, y, z) of the bottom point
        radius (float): A radious of the line
        color (list): A color color list (r, g, b)
    """
    x1, y1, z1 = map(float, p1)
    x2, y2, z2 = map(float, p2)
    r1, g1, b1 = map(float, color)
    r2, g2, b2 = map(float, color)
    radius = float(radius)
    # create a cone object
    return [
        cgo.CONE,
        x1, y1, z1,
        x2, y2, z2,
        radius, 0.0,
        r1, g1, b1,
        r2, g2, b2,
        1.0, 0.0
    ]


def arrow(p1, p2, radius, color, hlength=None, hradius=None):
    """
    Create an arrow compiled graphic object from two geometrical points

    Args
        p1 (list): A coordinate vector (x, y, z) of the top point
        p2 (list): A coordinate vector (x, y, z) of the bottom point
        radius (float): A radious of the line
        color (list): A color color list (r, g, b) or (r, g, b, a)
        hlength (None or float): A length of the hat
        hradius (None or float): A radius of the hat
    """
    if len(color) == 4:
        alpha = float(color[3])
        color = color[:3]
    else:
        alpha = 1.0
    if hlength is None:
        hlength = float(radius) * 3.0
    if hradius is None:
        hradius = float(hlength) * 0.6
    # calculate the length of the vector
    normal = cpv.normalize(cpv.sub(p1, p2))
    pM = cpv.add(cpv.scale(normal, hlength), p2)
    lineobj = line(p1, pM, radius, color)
    coneobj = cone(pM, p2, hradius, color)
    return [cgo.ALPHA, alpha] + lineobj + coneobj


def make_primitive(cgo, name=None, prefix='cgo'):
    """
    Create primitive
    """
    # find unique name if no name is specified
    if name is None:
        name = cmd.get_unused_name(prefix)
    # remove same name object
    cmd.delete(name)
    # store origianl value of auto_zoom
    original_auto_zoom = cmd.get('auto_zoom')
    # disable auto_zoom
    cmd.set('auto_zoom', 0.0)
    # create CGO
    cmd.load_cgo(cgo, name)
    # restore auto_zoom value
    cmd.set('auto_zoom', float(original_auto_zoom))


# Main ------------------------------------------------------------------------
def validate_vectors(vectors):
    """
    Validate 3D vector map
    """
    def validate_vector(vector):
        assert len(vector) == 6, (
            'ValidationError: '
            'The row of 3D vector map need to contain 6 columns which '
            'indicate (cx, cy, cz, dx, dy, dz) but the specified row '
            'only contains %d columns (%s).'
            'See "help(draw_quiver)" for more detail.'
        ) % (len(vector), ",".join(map(str, vector)))
    try:
        for vector in vectors:
            validate_vector(vector)
    except AssertionError, e:
        print "*" * 80
        print str(e)
        print "*" * 80
        return False
    return True


def draw_quiver(vectors, name=None, prefix='quiver',
                color=(0.5, 0.5, 0.5), scale=1.0, radius=0.02,
                hlength=None, hradius=None,
                min_length=None, max_length=None,
                length=None, relative=False,
                verbose=0, validation=False):
    """
    Create quiver CGO object (meshed vectors) from 3D vector map

    Args:
        vectors (list): A 3D vector map list. See 'Vectors' section.
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

    Vectors:
        This is a list of row. Each row must contain the following columns

        -   X coordinate of the origin of the vector
        -   Y coordinate of the origin of the vector
        -   Z coordinate of the origin of the vector
        -   X component of the vector
        -   Y component of the vector
        -   Z component of the vector

        A filename or file object can be specified as vector if the specified
        file contains the rows above and readable with 'numpy.loadtxt'
    """
    if validation:
        if verbose >= 1:
            print "Validating the specified vectors..."
        if not validate_vectors(vectors):
            return False

    if verbose >= 1:
        print "Calculating orientations and dimensions of vectors..."

    if relative:
        norms = [np.linalg.norm(v) for v in vectors[:, 3:]]
        min_vector = np.min(norms)
        max_vector = np.max(norms)
        norm_range = max_vector - min_vector
        to_relative = lambda n, o=min_vector, r=norm_range: (n - o) / r
    if verbose >= 1:
        print "Min vector: %f" % min_vector
        print "Max vector: %f" % max_vector
    else:
        to_relative = lambda n: n

    arrowobjs = []
    for i, vector in enumerate(vectors):
        p1 = np.array(vector[:3])
        v = np.array(vector[3:])
        n = to_relative(np.linalg.norm(v))
        if min_length is not None and n < min_length:
            continue
        if max_length is not None and n > max_length:
            continue
        # calculate end point
        if length:
            p2 = p1 + scale * length * (v / n)
        else:
            p2 = p1 + scale * v
        arrowobjs.extend(arrow(
            p1, p2,
            radius=radius, color=color,
            hlength=hlength, hradius=hradius,
        ))
        if verbose >= 2:
            print "%d: Norm: %.2f Relative: %.2f" % (i+1, np.linalg.norm(v), n)
            print "  Ori: (%.2f, %.2f, %.2f)" % (p1[0], p1[1], p1[2])
            print "  Dip: (%.2f, %.2f, %.2f)" % (v[0], v[1], v[2])

    if verbose >= 1:
        print "Creating CGO object..."
    make_primitive(arrowobjs, name=name, prefix=prefix)

    return True


# PyMOL command ---------------------------------------------------------------
def str2lst(s):
    """
    Convert string list expression to list
    """
    if isinstance(s, (list, tuple)):
        return s
    m = re.match("[\[\(](.*)[\]\)]", s)
    if m:
        return m.group(1).split(",")
    return s


def str2bool(s):
    """
    Convert strint bool expression to bool
    """
    if isinstance(s, bool):
        return s
    if s in ['true', 'True', '1', 'on', 'ON', 'On', 'TRUE']:
        return True
    return False


def _draw_quiver(vectors, **kwargs):
    """
    Create quiver CGO object (meshed vectors) from 3D vector map

    Usage:
        draw_quiver <vectors>
        draw_quiver <vectors>, [options]

    Args:
        vectors (list): A 3D vector map list. See 'Vectors' section.
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

    Vectors:
        This is a list of row. Each row must contain the following columns

        -   X coordinate of the origin of the vector
        -   Y coordinate of the origin of the vector
        -   Z coordinate of the origin of the vector
        -   X component of the vector
        -   Y component of the vector
        -   Z component of the vector

        A filename or file object can be specified as vector if the specified
        file contains the rows above and readable with 'numpy.loadtxt'
    """
    def prefer(names, default=None, conv=str):
        for name in names:
            if name in kwargs:
                return conv(kwargs.pop(name))
        return default
    # Option values
    name = prefer(('n', 'name'), None)
    prefix = prefer(('p', 'prefix'), 'quiver')
    color = prefer(('c', 'color'), [0.5, 0.5, 0.5], str2lst)
    scale = prefer(('s', 'scale'), 1.0, float)
    radius = prefer(('r', 'radius'), 0.02, float)
    hlength = prefer(('hlength',), None, float)
    hradius = prefer(('hradius',), None, float)
    min_length = prefer(('min', 'min_length'), None, float)
    max_length = prefer(('max', 'max_length'), None, float)
    length = prefer(('length',), None, float)
    relative = prefer(('relative',), False, str2bool)
    verbose = prefer(('verbose',), 0, int)
    validation = prefer(('validation',), False, str2bool)
    # raise exception with unknown kwargs
    kwargs.pop('_self')
    if len(kwargs) != 0:
        raise AttributeError((
            "Unknown options (%s) were specified."
        ) % ", ".join(kwargs.keys()))

    nkwargs = dict(
        name=name,
        prefix=prefix,
        radius=radius,
        color=color,
        scale=scale,
        hlength=hlength,
        hradius=hradius,
        min_length=min_length,
        max_length=max_length,
        length=length,
        relative=relative,
        verbose=verbose,
        validation=validation,
    )
    if isinstance(vectors, (basestring, file)):
        return draw_quiver(
            np.loadtxt(vectors),
            **nkwargs
        )
    else:
        return draw_quiver(
            vectors,
            **nkwargs
        )


# register the command
cmd.extend('draw_quiver', _draw_quiver)
