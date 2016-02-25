import re
import glob
import collections

Atom = collections.namedtuple('Atom', (
    'residue_name',
    'residue_id',
    'name',
))


HBond = collections.namedtuple('HBond', (
    'acceptor',
    'donor_h',
    'donor',
    'frames',
    'fraction',
    'distance',
    'angle',
))

builtin_terms = {
    'SolventAcc': Atom(
        residue_name='WAT',
        residue_id=0,
        name='O',
    ),
    'SolventH': Atom(
        residue_name='WAT',
        residue_id=0,
        name='H',
    ),
    'SolventDnr': Atom(
        residue_name='WAT',
        residue_id=0,
        name='O',
    ),
}

atom_pattern = re.compile(r'([^_]+)_(\d+)@(\S+)')
comment_pattern = re.compile(r'#.*$')


def _parse_atom(s):
    m = atom_pattern.match(s)
    if m:
        return Atom(
            residue_name=m.group(1),
            residue_id=int(m.group(2)),
            name=m.group(3),
        )
    elif s in builtin_terms:
        return builtin_terms[s]
    raise AttributeError('Unknown atom string "%s" was specified' % s)


def _parse_row(row):
    cols = row.split()
    if len(cols) != 7:
        raise AttributeError((
            'Unknown row string "%s" was specified. '
            'The correct format of the row is '
            '"Acceptor DonorH Donor Count Frac AvgDist AvgAng"'
        ) % row)
    return HBond(
        acceptor=_parse_atom(cols[0]),
        donor_h=_parse_atom(cols[1]),
        donor=_parse_atom(cols[2]),
        frames=int(cols[3]),
        fraction=float(cols[4]),
        distance=float(cols[5]),
        angle=float(cols[6]),
    )


def parse(fname):
    if isinstance(fname, (tuple, list)):
        hbonds = []
        for filename in fname:
            with open(filename) as fi:
                hbonds.extend(parse(fi))
        return hbonds
    if isinstance(fname, basestring):
        return parse([f for f in glob.iglob(fname)])

    def _iterate(fi):
        formatted = (comment_pattern.sub('', row).strip() for row in fi)
        for row in formatted:
            if row:
                yield _parse_row(row)
    return list(_iterate(fname))
