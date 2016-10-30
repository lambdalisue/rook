def guess_filename(pathspec, index=0, fail_silently=False):
    """Guess filename from a pathspec via glob.

    It return a first (or index) filename found from a specified
    glob.

    Args:
        pathspec (str): A glob style pathspec string
        index (int): An index used to determine filename (Default: 0)
        fail_silently (bool): Fail silently even if no filename is found.

    Return:
        String or None
    """
    from glob import glob
    filenames = glob(pathspec)
    if len(filenames) > index:
        return filenames[index]
    elif fail_silently:
        return None
    else:
        raise IOError('No file is found for "%s" with an index "%d"' % (
            pathspec, index,
        ))
