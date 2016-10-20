# coding: utf-8
#===============================================================================
# Name:         track_atoms.py
# Description:  draw tracking arrows for atoms trajectory (iterate states)
# Author:       Alisue <lambdalisue@hashnote.net>
# License:      MIT license
# Required:     colour, natsort, pymol, chempy
# (C) 2014, hashnote.net, Alisue
#===============================================================================
import re
import math
import colour
import natsort
import itertools
import threading
import multiprocessing
from pymol import cmd
from pymol import cgo
from chempy import cpv


# --- Default values
DEFAULT_RADIUS = 0.02
DEFAULT_RGB = (0.8, 0.8, 0.8)
DEFAULT_PREFIX = 'track'


class ProgressBar(object):
    def __init__(self, maxval, textwidth=50):
        self.maxval = maxval
        self.textwidth = textwidth
        self.cursor = 0

    def update(self):
        self.cursor += 1

    @property
    def ratio(self):
        return self.cursor / float(self.maxval)

    @property
    def percent(self):
        return round(self.ratio * 100)

    def __str__(self):
        ratio = self.ratio
        percent = "%3d%%" % self.percent
        # 3 for '|| '
        blackbar = int(round((self.textwidth - len(percent) - 3) * ratio))
        whitebar = (self.textwidth - len(percent) - 3) - blackbar
        blackbar = "#" * blackbar
        whitebar = " " * whitebar
        return "|%s%s| %s" % (blackbar, whitebar, percent)

def line(p1, p2, radius, rgb):
    """
    Create a line object from two geometrical points
    """
    x1, y1, z1 = map(float, p1)
    x2, y2, z2 = map(float, p2)
    r1, g1, b1 = map(float, rgb)
    r2, g2, b2 = map(float, rgb)
    radius = float(radius)
    # create a line object (cylinder object)
    lineobj = [cgo.CYLINDER, x1, y1, z1, x2, y2, z2, radius,
               r1, g1, b1, r2, g2, b2]
    return lineobj

def cone(p1, p2, radius, rgb):
    """
    Create a cone object from two geometrical points
    """
    x1, y1, z1 = map(float, p1)
    x2, y2, z2 = map(float, p2)
    r1, g1, b1 = map(float, rgb)
    r2, g2, b2 = map(float, rgb)
    radius = float(radius)
    # create a cone object
    coneobj = [cgo.CONE, x1, y1, z1, x2, y2, z2, radius, 0.0,
               r1, g1, b1, r2, g2, b2, 1.0, 0.0]
    return coneobj

def arrow(p1, p2, radius, rgb, hlength=None, hradius=None):
    """
    Create an arrow object from two geometrical points
    """
    if hlength is None:
        hlength = float(radius) * 3.0
    if hradius is None:
        hradius = float(hlength) * 0.6
    # calculate the length of the vector
    normal = cpv.normalize(cpv.sub(p1, p2))
    pM = cpv.add(cpv.scale(normal, hlength), p2)
    lineobj = line(p1, pM, radius, rgb)
    coneobj = cone(pM, p2, hradius, rgb)
    return lineobj + coneobj

def make_primitive(cgo, name=None, prefix='cgo', force=True):
    """
    Create primitive
    """
    # find unique name if no name is specified
    if name is None:
        name = cmd.get_unused_name(prefix)
    # remove same name object
    if force:
        cmd.delete(name)
    # store origianl value of auto_zoom
    original_auto_zoom = cmd.get('auto_zoom')
    # disable auto_zoom
    cmd.set('auto_zoom', 0.0)
    # create CGO
    cmd.load_cgo(cgo, name)
    # restore auto_zoom value
    cmd.set('auto_zoom', float(original_auto_zoom))

def str2lst(s):
    """
    Convert string list expression to list
    """
    if isinstance(s, (list, tuple)):
        return s
    p = str2lst.__pattern
    m = p.match(s)
    if m:
        return m.group(1).split(",")
    return s
str2lst.__pattern = re.compile("[\[\(](.*)[\]\)]")

def str2bool(s):
    """
    Convert strint bool expression to bool
    """
    if isinstance(s, bool):
        return s
    if s in ['true', 'True', '1', 'on', 'ON', 'On', 'TRUE']:
        return True
    return False

def str2color(s, steps):
    if isinstance(s, basestring):
        if s == 'rainbow':
            c1 = colour.Color('blue')
            c2 = colour.Color('red')
        elif s == 'PuBu':
            c1 = colour.Color('white')
            c2 = colour.Color('blue')
        else:
            raise AttributeError("Unknown colormap name is specified.")
        cs = c1.range_to(c2, steps)
        return [(c.red, c.green, c.blue) for c in cs]
    elif isinstance(s, (list, tuple)):
        if len(s) == 3:
            s = tuple(map(float, s))
            return itertools.cycle([s])
        elif len(s) == 2:
            c1 = colour.Color(s[0].strip())
            c2 = colour.Color(s[1].strip())
            cs = c1.range_to(c2, steps)
            return [(c.red, c.green, c.blue) for c in cs]
        elif len(s) == 1:
            return str2color(s[0], steps)
        else:
            raise AttributeError("Unknown color (%s) is specified." % s)
    return itertools.cycle(s)

def norm(p1, p2):
    """
    Calculate the norm between two points
    """
    p = [p2[i]-p1[i] for i in range(len(p2))]
    return math.sqrt(sum(map(lambda x: x**2, p)))

def trace_atoms(selection,
                linewidth=0.02,
                linecolors='rainbow',
                name=None,
                split_traces=False,
                trace_start=1, trace_end=-1,
                cutoff_center=None, cutoff_center_selection=None,
                cutoff_min_radius=None,
                cutoff_max_radius=None,
                cutoff_min_length=None,
                cutoff_max_length=None,
                cutoff_min_segments=None,
                cutoff_max_segments=None,
                pushover_userid=None,
                verbose=1):
    """
    Create segmented arrow CGO objects to indicate the atoms' trace

    Args:
        selection (string): A pymol selection to indicate the atoms
        linewidth (float): A width of the lines in unit Angstrom. Default is
            `0.02`
        linecolors (string or list): A colormap name string or color list.
            The default value is `rainbow`
        name (None or string): An name of the CGO object. If it is not
            specified, continuous numbered name will be used instead
        split_traces (bool): If it is specified, individual CGO objects will be
            created for individual atoms (square blanket indicate the INDEX of
            the atom). Default is `False`
        trace_start (int): A start index of the state. A negative value indicate
            the index counted from the last state. Default is `1`
        trace_end (int): An end index of the state. A negative value indicate
            the index counted from the last state. Default is `-1`
        cutoff_center (list): A central coordinate (three floats list) of
            cutting off center. It is required to use with `cutoff_XXX_radius`
            and it cannot be used with `cutoff_center_selection`
        cutoff_center_selection (string): A pymol selection to indicate the
            cutting off center. It is required to use with `cutoff_XXX_radius`
            and it cannot be used with `cutoff_center`
        cutoff_min_radius (float): A minimum radius of the cutting off sphere
            in unit Angstrom. The atoms closer than this radius will be ignored.
        cutoff_max_radius (float): A maximum radius of the cutting off sphere
            in unit Angstrom. The atoms more distant than this radius will be
            ignored.
        cutoff_min_length (flaot): A minimum length of the lines in unit
            Angstrom. The lines shorter than this value will be ignored.
        cutoff_max_length (flaot): A maximum length of the lines in unit
            Angstrom. The lines longer than this value will be ignored.
        cutoff_min_segments (int): A minimum number of the segments.
            The lines constructed with less segments than this value will be
            ignored.
        cutoff_max_segments (int): A maximum number of the segments.
            The lines constructed with more segments than this value will be
            ignored.
        pushover_userid (str): An user key of pushover service.
            This require 'python-pushover' in your system.
        verbose (int): A level of output information. 0, 1, and 2 indicate
            'No output', 'Normal output', and 'Debug output' respectively
    """
    # regulate state indexes
    nmax_states = cmd.count_states('(all)')
    if trace_start < 0: trace_start = nmax_states - (trace_start + 1)
    if trace_end < 0: trace_end = nmax_states - (trace_end + 1)
    # process and validate the options
    if cutoff_center and cutoff_center_selection:
        raise AttributeError(
                "`cutoff_center` and `cutoff_center_selection` cannot be used "
                "together")
    if cutoff_center_selection:
        def get_cutoff_center(state):
            minc, maxc = cmd.get_extent(cutoff_center_selection, state=state)
            midc = [minc[i]+(maxc[i]-minc[i])/2 for i in range(len(minc))]
            return midc
        cutoff_center = get_cutoff_center(0)
    if cutoff_center and not (cutoff_min_radius or cutoff_max_radius):
        raise AttributeError(
                "`cutoff_center` need to be used with `cutoff_min_radius` "
                "or `cutoff_max_radius` together")
    # store 3D coordinates of states for atoms
    segments = {}
    previous = {}
    enableds = {}
    looplength = trace_end + 1 - trace_start
    progress = ProgressBar(looplength)
    for state in range(looplength):
        model = cmd.get_model(selection, state=(trace_start + state))
        if verbose > 0:
            previous_percent = progress.percent
            progress.update()
            if previous_percent != progress.percent:
                print progress
        for atom in model.atom:
            if atom.index not in segments:
                segments[atom.index] = []
                previous[atom.index] = atom.coord
                enableds[atom.index] = False
                continue
            p1 = previous[atom.index]
            p2 = atom.coord
            # update previous
            previous[atom.index] = atom.coord
            # cutoff sphere check
            if cutoff_center is not None:
                # calculate the length from the center to current coord
                radius = norm(cutoff_center, p2)
                if cutoff_min_radius is not None and radius < cutoff_min_radius:
                    continue
                if cutoff_max_radius is not None and radius > cutoff_max_radius:
                    continue
            # cutoff length check
            length = norm(p1, p2)
            if cutoff_min_length is not None and length < cutoff_min_length:
                continue
            if cutoff_max_length is not None and length > cutoff_max_length:
                continue
            # add coordinates
            segments[atom.index].append((p1, p2))
            nsegments = len(segments[atom.index])
            if (cutoff_min_segments is not None and
                    nsegments < cutoff_min_segments):
                enableds[atom.index] = False
            elif (cutoff_max_segments is not None and
                    nsegments > cutoff_max_segments):
                enableds[atom.index] = False
            else:
                enableds[atom.index] = True

    # create CGO object
    if verbose > 1:
        print "Creating CGO sequences..."
    indexes = natsort.natsorted(list(segments.keys()))
    indexes = [index for index in indexes if enableds[index]]
    linecolors = str2color(linecolors, len(indexes))
    lineradius = linewidth/2.0
    for index, color in zip(indexes, linecolors):
        segment = segments[index]
        segments[index] = []
        for p1, p2 in segment:
            segments[index].extend(arrow(p1, p2, lineradius, color))
    # draw CGO object
    if verbose > 1:
        print "Loading CGO objects..."
    if split_traces:
        name = name or 'trace'
        for index in indexes:
            segment = segments[index]
            make_primitive(segment, name=name + "[%s]" % index)
    else:
        # convert dict to list
        segments = [segments[index] for index in indexes]
        segments = list(itertools.chain.from_iterable(segments))
        # create CGO object
        make_primitive(segments, name, 'trace')
    if verbose > 0:
        print "%d atoms were traced" % len(indexes)
        _indexes = "+".join(map(str, indexes))
        print "Use 'select TRACED, index %s'" % _indexes

    if pushover_userid is not None:
        try:
            import pushover
            pushover.init("aP9RVFDk3EggocgKHxbHmEvNDXFswa")
            client = pushover.Client(pushover_userid)
            client.send_message("Tracing atoms of '%s' has finished. "
                                "%d atoms were traced" % (selection,
                                    len(indexes)))
        except ImportError:
            print "You need to install 'python-pushover' to enable pushover"
    return indexes


def _trace_atoms(selection, **kwargs):
    """
    Create segmented arrow CGO objects to indicate the atoms' trace

    Usage:
        trace_atoms selection, <options>

    Examples:
        # trace O atoms of WAT within 10 A from (0.2, 0.2, 0.2)
        trace_atoms (resn WAT and name O), cc=(0.2, 0.2, 0.2), cxr=10

    Options:
        selection: A pymol selection to indicate the atoms
        linewidth (w, width): A width of the lines in unit Angstrom.
            Default is `0.02`
        linecolors (string or list): A colormap name string or color list.
            The default value is `rainbow`
        name (n): An name of the CGO object. If it is not specified, continuous
            numbered name will be used instead
        split_traces (split): If it is specified, individual CGO objects will be
            created for individual atoms (square blanket indicate the INDEX of
            the atom). Default is `False`
        trace_start (s, start): A start index of the state. A negative value
            indicate the index counted from the last state. Default is `1`
        trace_end (e, end): An end index of the state. A negative value indicate
            the index counted from the last state. Default is `-1`
        cutoff_center (cc, center): A central coordinate (three floats list) of
            cutting off center. It is required to use with `cutoff_XXX_radius`
            and it cannot be used with `cutoff_center_selection`
        cutoff_center_selection (ccs, center_selection): A pymol selection to
            indicate the cutting off center. It is required to use with
            `cutoff_XXX_radius` and it cannot be used with `cutoff_center`
        cutoff_min_radius (cnr, min_radius): A minimum radius of the cutting off
            sphere in unit Angstrom. The atoms closer than this radius will be
            ignored.
        cutoff_max_radius (cxr, max_radius): A maximum radius of the cutting off
            sphere in unit Angstrom. The atoms more distant than this radius
            will be ignored.
        cutoff_min_length (cnl, min_length): A minimum length of the lines in
            unit Angstrom. The lines shorter than this value will be ignored.
        cutoff_max_length (cxl, max_length): A maximum length of the lines in
            unit Angstrom. The lines longer than this value will be ignored.
        cutoff_min_segments (cns, min_segments): A minimum number of the segments.
            The lines constructed with less segments than this value will be
            ignored.
        cutoff_max_segments (cxs, max_segments): A maximum number of the segments.
            The lines constructed with more segments than this value will be
            ignored.
        pushover_userid (push, pushover): An user key of pushover service.
            This require 'python-pushover' in your system.
        verbose (v): A level of output information. 0, 1, and 2 indicate
            'No output', 'Normal output', and 'Debug output' respectively
    """
    def prefer(names, default=None, _type=str):
        for name in names:
            if name in kwargs: return _type(kwargs.pop(name))
        return default
    # get option value from kwargs
    linewidth = prefer(('w', 'width', 'linewidth'), 0.02, float)
    linecolors = prefer(('c', 'colors', 'linecolors'), 'rainbow', str2lst)
    name = prefer(('n', 'name'), None)
    split_traces = prefer(('split', 'split_traces'), None, str2bool)
    trace_start = prefer(('s', 'start', 'trace_start'), 1, int)
    trace_end = prefer(('e', 'end', 'trace_end'), -1, int)
    cutoff_center = prefer(('cc', 'center', 'cutoff_center'), None, str2lst)
    cutoff_center_selection = prefer(
            ('ccs', 'center_selection', 'cutoff_center_selection'), None)
    cutoff_min_radius = prefer(('cnr', 'min_radius', 'cutoff_min_radius'), None,
            float)
    cutoff_max_radius = prefer(('cxr', 'max_radius', 'cutoff_max_radius'), None,
            float)
    cutoff_min_length = prefer(('cnl', 'min_length', 'cutoff_min_length'), None,
            float)
    cutoff_max_length = prefer(('cxl', 'max_length', 'cutoff_max_length'), None,
            float)
    cutoff_min_segments = prefer(('cns', 'min_segments', 'cutoff_min_segments'),
            None, float)
    cutoff_max_segments = prefer(('cxs', 'max_segments', 'cutoff_max_segments'),
            None, float)
    pushover_userid = prefer(('push', 'pushover', 'pushover_userid'), None)
    verbose = prefer(('v', 'verbose'), 1, int)
    # if unknown kwargs were specified, raise exception
    kwargs.pop('_self')
    if len(kwargs) != 0:
        raise AttributeError("Unknown options (%s) were specified." % (
            ", ".join(kwargs.keys())))

    thread = threading.Thread(
    #thread = multiprocessing.Process(
        target=trace_atoms, args=(selection,), kwargs=dict(
            linewidth=linewidth,
            linecolors=linecolors,
            name=name,
            split_traces=split_traces,
            trace_start=trace_start, trace_end=trace_end,
            cutoff_center=cutoff_center,
            cutoff_center_selection=cutoff_center_selection,
            cutoff_min_radius=cutoff_min_radius,
            cutoff_max_radius=cutoff_max_radius,
            cutoff_min_length=cutoff_min_length,
            cutoff_max_length=cutoff_max_length,
            cutoff_min_segments=cutoff_min_segments,
            cutoff_max_segments=cutoff_max_segments,
            pushover_userid=pushover_userid,
            verbose=verbose,
        )
    )
    thread.start()

# register the command
cmd.extend('trace_atoms', _trace_atoms)
