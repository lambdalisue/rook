# coding=utf-8
import re
from functools import wraps
from pymol import cmd
from pymol import cgo
from chempy import cpv


def to_color(c):
    if isinstance(c, list):
        return c
    elif isinstance(c, (int, float)):
        return c
    else:
        m = re.match(c, '^[(\d+),\s*(\d+),\s*(\d+)]$')
        if m:
            return [
                float(m.group(1)),
                float(m.group(2)),
                float(m.group(3)),
            ]
        else:
            return 0


class CGO(object):
    _primitive = []

    @property
    def primitive(self):
        return self._primitive

    def create(self, name=None, prefix='cgo', alpha=1.0, state=0):
        """
        Create a compiled graphic object with given name
        """
        if name is None:
            name = cmd.get_unused_name(prefix)
        # remove a object which has a same name
        cmd.delete(name)
        # store origianl value of auto_zoom
        original_auto_zoom = cmd.get('auto_zoom')
        # disable auto_zoom
        cmd.set('auto_zoom', 0.0)
        # create CGO
        cmd.load_cgo(
            [cgo.ALPHA, float(alpha)] + self.primitive, name, state=state
        )
        # restore auto_zoom value
        cmd.set('auto_zoom', float(original_auto_zoom))

    def __add__(self, other):
        """
        Create a new CGO from two CGOs
        """
        cgo = CGO()
        cgo._primitive = self._primitive + other._primitive
        return cgo


class Sphere(CGO):
    """
    A sphere compiled graphic object
    """
    def __init__(self, p, radius, c):
        """
        Constructor

        Args:
            p (list): A coordinate vector (x, y, z) of the center of the sphere
            radius (float): A radious of the sphere
            c (list): A color list (red, green, blue) of the sphere
        """
        x, y, z = map(float, p)
        r, g, b = map(float, c)
        radius = float(radius)
        self._primitive = [
            cgo.COLOR,
            r, g, b,
            cgo.SPHERE,
            x, y, z,
            radius,
        ]


class Cylinder(CGO):
    """
    A cylinder compiled graphic object
    """
    def __init__(self, p1, p2, radius, c1, c2=None):
        """
        Constructor

        Args:
            p1 (list): A coordinate vector (x, y, z) of the point 1
            p2 (list): A coordinate vector (x, y, z) of the point 2
            radius (float): A radious of the cylinder
            c1 (list): A color list (red, green, blue) of the point 1
            c2 (list or None): A color list (red, green, blue) of the point 2
        """
        x1, y1, z1 = map(float, p1)
        x2, y2, z2 = map(float, p2)
        r1, g1, b1 = map(float, c1)
        r2, g2, b2 = map(float, c2 or c1)
        radius = float(radius)
        self._primitive = [
            cgo.CYLINDER,
            x1, y1, z1,
            x2, y2, z2,
            radius,
            r1, g1, b1,
            r2, g2, b2
        ]


class Cone(CGO):
    """
    A cone compiled graphic object
    """
    def __init__(self, p1, p2, radius1, c1, radius2=0, c2=None):
        x1, y1, z1 = map(float, p1)
        x2, y2, z2 = map(float, p2)
        r1, g1, b1 = map(float, c1)
        r2, g2, b2 = map(float, c2 or c1)
        radius1 = float(radius1)
        radius2 = float(radius2)
        # create a cone object
        # https://www.jiscmail.ac.uk/cgi-bin/webadmin?A2=CCP4BB;8318a2d9.1008
        self._primitive = [
            cgo.CONE,
            x1, y1, z1,         # coordinate of the base of the cone
            x2, y2, z2,         # coordinate of the tip of the cone
            radius1, radius2,   # radius of the base and tip of the cone
            r1, g1, b1,         # color for the base of the cone
            r2, g2, b2,         # color for the tip of the cone
            1,                  # if '1' the base of the cone is filled in
            0,                  # if '1' the tip of the cone is filled in
        ]


class Arrow(CGO):
    """
    An arrow compiled graphic object
    """
    def __init__(self, p1, p2, radius, c1,
                 c2=None, c3=None,
                 hlength=None, hradius=None,
                 hlength_scale=3.0, hradius_scale=0.6):
        if hlength is None:
            hlength = float(radius) * hlength_scale
        if hradius is None:
            hradius = float(hlength) * hradius_scale
        normal = cpv.normalize(cpv.sub(p1, p2))
        pM = cpv.add(cpv.scale(normal, hlength), p2)
        line = Cylinder(p1, pM, radius, c1, c2)
        cone = Cone(pM, p2, hradius, c2 or c1, radius2=0, c2=c3)
        self._primitive = (line + cone).primitive


def verbose(fn, pattern="{}"):
    @wraps(fn)
    def inner(*args, **kwargs):
        if '_self' in kwargs:
            kwargs.pop('_self')
        result = fn(*args, **kwargs)
        if result:
            print pattern.format(*result)
    return inner


def find_coc_selection(selection, state=0):
    """
    Find center of coordinates of the selection and return the value

    USAGE

        find_coc_selection selection
        find_coc_selection selection, state=state

    ARGUMENTS

        selection   a selection-expression
        state       a state-index if positive number or 0 to all, -1 to current

    EXAMPLE

        find_coc_selection resn PHE, state=10
        fcoc resn PHE, state=10
    """
    # find middle x, y, z coordinate of the selection
    minc, maxc = cmd.get_extent(selection, state=state)
    coc = [float(l + (u - l) / 2.0) for l, u in zip(minc, maxc)]
    return coc


def find_com_selection(selection, state=0):
    """
    Find center of mass of the selection and return the value

    USAGE

        find_com_selection selection
        find_com_selection selection, state=state

    ARGUMENTS

        selection   a selection-expression
        state       a state-index if positive number or 0 to all, -1 to current

    EXAMPLE

        find_com_selection resn PHE, state=10
        fcom resn PHE, state=10
    """
    model = cmd.get_model(selection, state=state)
    com = cpv.get_null()
    # iterate all atoms and add vectors of center of mass of each atoms
    for atom in model.atom:
        com = cpv.add(com, atom.coord)
    com = cpv.scale(com, 1.0 / len(model.atom))
    return com


def draw_sphere_on_coc_selection(selection,
                                 state=0,
                                 name=None, prefix='coc',
                                 radius=1.0, color=(0.5, 0.5, 0.5), alpha=0.5):
    """
    Draw a sphere which indicate a center of coordinate of the selection

    USAGE

        draw_sphere_on_coc_selection selection,
                                     state=state,
                                     name=name,
                                     prefix=prefix,
                                     readius=radius,
                                     color=color,
                                     alpha=alpha

    ARGUMENTS

        selection   a selection-expression
        state       a state-index if positive number or 0 to all, -1 to current
        name        a name of the compiled graphic object, it will
                    automatically specified if None is specified (Default)
        prefix      a prefix of the compiled graphic object. it will used
                    only when name is not specified
        radius      a raidus of the sphere in float
        color       a color of the sphere
        alpha       a alpha-value of the sphere

    EXAMPLE

        draw_sphere_on_coc_selection resn PHE, state=10, radius=3.2
        dcoc resn PHE, state=10, radius=3.2
    """
    coc = find_coc_selection(selection, state=state)
    sphere = Sphere(coc, radius, to_color(color))
    sphere.create(name, prefix, alpha)


def draw_sphere_on_com_selection(selection,
                                 state=0,
                                 name=None, prefix='com',
                                 radius=1.0, color=(0.5, 0.5, 0.5), alpha=0.5):
    """
    Draw a sphere which indicate a center of mass of the selection

    USAGE

        draw_sphere_on_com_selection selection,
                                     state=state,
                                     name=name,
                                     prefix=prefix,
                                     readius=radius,
                                     color=color,
                                     alpha=alpha

    ARGUMENTS

        selection   a selection-expression
        state       a state-index if positive number or 0 to all, -1 to current
        name        a name of the compiled graphic object, it will
                    automatically specified if None is specified (Default)
        prefix      a prefix of the compiled graphic object. it will used
                    only when name is not specified
        radius      a raidus of the sphere in float
        color       a color of the sphere
        alpha       a alpha-value of the sphere

    EXAMPLE

        draw_sphere_on_com_selection resn PHE, state=10, radius=3.2
        dcom resn PHE, state=10, radius=3.2
    """
    com = find_coc_selection(selection, state=state)
    sphere = Sphere(com, radius, to_color(color))
    sphere.create(name, prefix, alpha)


def create_pseudo_on_coc_selection(selection,
                                   state=None, append=True, name=None,
                                   prefix='', suffix='_coc', **kwargs):
    """
    Create a pseudoatom which indicate the center of coordinates of the
    selection

    USAGE

        create_pseudo_on_coc_selection selection,
                                       state=state,
                                       append=True|False,
                                       name=name,
                                       prefix='',
                                       suffix='_coc'

    ARGUMENTS

        selection   a selection-expression
        state       a state-index if positive number or 0 to all, -1 to current
        name        a name of the pseudoatom, it will
                    automatically specified if None is specified (Default)
        prefix      a prefix of the pseudoatom. it will used only when name is
                    not specified
        suffix      a suffix of the pseudoatom. it will used only when name is
                    not specified
        alpha       a alpha-value of the sphere

    EXAMPLE

        create_pseudo_on_coc_selection resn PHE, state=10
        ccoc resn PHE, state=10
    """
    if name is None:
        try:
            name = cmd.get_legal_name(selection)
            name = cmd.get_unused_name(
                '{}{}{}'.format(prefix, name, suffix), 0
            )
        except:
            name = '%s%s' % (prefix, suffix)

    if state is not None:
        coc = find_coc_selection(selection, state=state)
        cmd.pseudoatom(name, pos=coc, **kwargs)
    else:
        for state in range(1, cmd.count_states()+1):
            coc = find_coc_selection(selection, state=state)
            cmd.pseudoatom(name, pos=coc, state=state, **kwargs)


def create_pseudo_on_com_selection(selection,
                                   state=None, name=None,
                                   prefix='', suffix='_com', **kwargs):
    """
    Create a pseudoatom which indicate the center of mass of the selection

    USAGE

        create_pseudo_on_coM_selection selection,
                                       state=state,
                                       append=True|False,
                                       name=name,
                                       prefix='',
                                       suffix='_coc'

    ARGUMENTS

        selection   a selection-expression
        state       a state-index if positive number or 0 to all, -1 to current
        name        a name of the pseudoatom, it will
                    automatically specified if None is specified (Default)
        prefix      a prefix of the pseudoatom. it will used only when name is
                    not specified
        suffix      a suffix of the pseudoatom. it will used only when name is
                    not specified
        alpha       a alpha-value of the sphere

    EXAMPLE

        create_pseudo_on_com_selection resn PHE, state=10
        ccom resn PHE, state=10
    """
    if name is None:
        try:
            name = cmd.get_legal_name(selection)
            name = cmd.get_unused_name(
                '{}{}{}'.format(prefix, name, suffix), 0
            )
        except:
            name = '%s%s' % (prefix, suffix)

    if state is not None:
        com = find_com_selection(selection, state=state)
        cmd.pseudoatom(name, pos=com, **kwargs)
    else:
        for state in range(1, cmd.count_states()+1):
            com = find_com_selection(selection, state=state)
            cmd.pseudoatom(name, pos=com, state=state, **kwargs)


cmd.extend('find_coc_selection',
           verbose(find_coc_selection, 'COC: {:.6f} {:.6f} {:.6f}'))
cmd.extend('fcoc',
           verbose(find_coc_selection, 'COC: {:.6f} {:.6f} {:.6f}'))
cmd.extend('find_com_selection',
           verbose(find_com_selection, 'COM: {:.6f} {:.6f} {:.6f}'))
cmd.extend('fcom',
           verbose(find_com_selection, 'COM: {:.6f} {:.6f} {:.6f}'))

cmd.extend('draw_sphere_on_coc_selection', draw_sphere_on_coc_selection)
cmd.extend('dcoc', draw_sphere_on_coc_selection)
cmd.extend('draw_sphere_on_com_selection', draw_sphere_on_com_selection)
cmd.extend('dcom', draw_sphere_on_com_selection)

cmd.extend('create_pseudo_on_coc_selection', create_pseudo_on_coc_selection)
cmd.extend('ccoc', create_pseudo_on_coc_selection)
cmd.extend('create_pseudo_on_com_selection', create_pseudo_on_com_selection)
cmd.extend('ccom', create_pseudo_on_coc_selection)
