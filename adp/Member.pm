#
# $Id$
#

package ADPatch::Member;
use strict;

sub new {
    my $class = shift;
    my $name  = shift;
    my $self = {
            FILENAME    => undef ,
            BASENAME    => undef ,
            EXT         => undef ,
            IS_BIN      => undef ,
            DEST        => undef ,
            CMD_COPY    => undef ,
            CMD_EXEC    => undef ,
            SVN_ID      => undef ,
            RCS_ID      => undef ,
        };

    _init( $name );

    bless( $self, $class );
    return $self;
}

sub _init {
    my $name = shift;
    my %p;
    my ($prd,$gap,$ver) = $name ~= m{};

    return %p;
}

1;
