package URI::Hatena::Normalizer::<+CURSOR+>;
use strict;
use warnings;
use utf8;

sub normalize {
    my ($class, $url) = @_;

    my $path = $url->path;
    $url->path($path) if $path =~ s!^/s/!/!;

    return $url;
}

1;
