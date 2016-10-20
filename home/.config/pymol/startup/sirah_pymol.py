#==============================================================================
# A pymol script to help SIRAH users
#
# Author:   Alisue (lambdalisue@hashnote.net)
# License:  MIT license
#
#==============================================================================
from pymol import cmd

def _sirah_set_radii(verbose=0):
    """Set SIRAH vdW radii to atoms

    USAGE

        sirah_set_radii
        sirah_set_radii verbose=1

    """
    SIRAH_ATOMTYPES = (
        # type    sigma(nm)   element
        ('GNaz',  0.45000,    'N'),
        ('GObz',  0.45000,    'O'),
        ('GNan',  0.45000,    'N'),
        ('GObn',  0.45000,    'O'),
        ('GN',    0.40000,    'N'),
        ('GO',    0.40000,    'O'),
        ('GC',    0.40000,    'C'),
        ('Y1C',   0.41000,    'C'),
        ('Y2Ca',  0.41000,    'C'),
        ('Y3Sm',  0.45000,    'S'),
        ('Y4Cv',  0.41000,    'C'),
        ('Y5Sx',  0.45000,    'S'),
        ('Y6Cp',  0.43000,    'C'),
        ('A1C',   0.35000,    'C'),
        ('A1Cw',  0.35000,    'C'),
        ('A2C',   0.35000,    'C'),
        ('A3P',   0.35000,    'H'),
        ('A4O',   0.35000,    'O'),
        ('A5No',  0.35000,    'N'),
        ('A6No',  0.35000,    'N'),
        ('A5Nu',  0.35000,    'N'),
        ('A6Nu',  0.35000,    'N'),
        ('A7N',   0.35000,    'N'),
        ('A8P',   0.35000,    'H'),
        ('P1O',   0.41000,    'O'),
        ('P1S',   0.41000,    'S'),
        ('P2P',   0.40000,    'H'),
        ('P3Cn',  0.40000,    'C'),
        ('P3Cq',  0.40000,    'C'),
        ('P4O',   0.40000,    'O'),
        ('P5N',   0.40000,    'N'),
        ('C1Ck',  0.40000,    'C'),
        ('C2Cr',  0.40000,    'C'),
        ('C3Cr',  0.40000,    'C'),
        ('C4Cd',  0.40000,    'C'),
        ('C4Ce',  0.40000,    'C'),
        ('C5N',   0.45000,    'N'),
        ('C6O',   0.45000,    'O'),
        ('C7Nk',  0.55000,    'N'),
        ('C8C',   0.40000,    'C'),
        ('PX',    0.46327,    'P'),
        ('KX',    0.42906,    'C'),
        ('KN',    0.33997,    'C'),
        ('CX',    0.26698,    'H'),
        ('NF',    0.32500,    'N'),
        ('NL',    0.32500,    'N'),
        ('NR',    0.32500,    'N'),
        ('NS',    0.32500,    'N'),
        ('NU',    0.32500,    'N'),
        ('NW',    0.32500,    'N'),
        ('NX',    0.32500,    'N'),
        ('OV',    0.29599,    'O'),
        ('OX',    0.29599,    'O'),
        ('OY',    0.29599,    'O'),
        ('OZ',    0.29599,    'O'),
        ('WT',    0.42000,    'X'),
        ('NaW',   0.58000,    'Na'),
        ('KW',    0.64500,    'K'),
        ('ClW',   0.68000,    'Cl'),
        ('MgW',   0.37500,    'Mg'),
        ('I1',    0.64500,    'K'),
        ('I2',    0.58000,    'Na'),
        ('I3',    0.68000,    'Cl'),
    )
    for text_type, sigma, element in SIRAH_ATOMTYPES:
        # vdw radius = rm/2 = 2^(1.6) * sigma / 2
        selection = 'text_type %s' % text_type
        expression = "vdw=%f" % (
            10 * pow(2, 1.0/6) * sigma / 2.0,
        )
        cmd.alter(selection, expression)
        if verbose:
            print "alter (%s), %s" % (selection, expression)
        expression = "elem='%s'" % element
        cmd.alter(selection, expression)
        if verbose:
            print "alter (%s), %s" % (selection, expression)
    cmd.rebuild()
cmd.extend('sirah_set_radii', _sirah_set_radii)


def _sirah_select(name_or_selection, selection=None):
    """Select SIRAH molecules

    USAGE

        sirah_select (selection)
        sirah_select name, (selection)

    ARGUMENTS

        name        a unique name for the selection
        selection   a selection-expression. the SIRAH-KEYWORDS will
                    automatically replaced to a corresponding
                    selection-expression

    SIRAH-KEYWORDS

        nucleic     represent nucleic acids of SIRAH
        protein     represent protein amino acids of SIRAH
        basic       represent basic amino acids of SIRAH
        polar       represent polar amino acids of SIRAH
        neutral     represent neutral amino acids of SIRAH
        backbone    represent backbone atoms of protein of SIRAH
        water       represent water molecule of SIRAH
        ions        represent ion molecules of SIRAH

    EXAMPLES

        select chA, chain A
        select interestA, (chain A and protein) or (chain B and nucleic)

    """
    if not selection:
        name = 'sele'
        selection = name_or_selection
    else:
        name = name_or_selection
    substitute_patterns = (
        ('nucleic', 'resn %s' % '+'.join([
            'DAX+DTX+DGX+DCX',
            'AX5+TX5+GX5+CX5',
            'AX3+TX3+GX3+CX3',
            'ADX+ATX+CMX',
        ])),
        ('protein', 'resn %s' % '+'.join([
            'sK+sR+sHp+sHd+sHe',
            'sE+sD+sN+sQ+sS+sT',
            'sY+sA+sC+sX+sG+sI',
            'sL+sM+sF+sP+sW+sV',
        ])),
        ('basic', 'resn sK+sR+sHp+sHd+sHe'),
        ('acidic', 'resn sE+sD'),
        ('polar', 'resn sN+sQ+sS+sT+sY'),
        ('neutral', 'resn %s' % '+'.join([
            'sA+sC+sX+sG+sI+sL',
            'sM+sF+sP+sW+sV',
        ])),
        ('backbone', (
            'name GN+GC+GO or '
            '(text_type PX+KX+KN and not resn ADX+ATX+CMX)'
        )),
        ('water', 'resn WT4'),
        ('ions', 'resn KW+NaW+ClW+MgW'),
    )
    for pattern, repl in substitute_patterns:
        selection = selection.replace(pattern, repl)
    print selection
    cmd.select(name, selection)
cmd.extend('sirah_select', _sirah_select)
