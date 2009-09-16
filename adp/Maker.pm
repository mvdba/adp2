#
# $Id$
#

package ADPatch::Maker;
use strict;

sub new {
    my $class = shift;
    my $name  = shift;
    my $self = {
            NAME        => undef ,
            PRD         => undef ,
            GAP         => undef ,
            GAP_VER     => undef ,
            FILE_NAME   => undef ,
            DRIVER      => undef ,
            _members    => []    ,
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

sub add_file {
    my $member = shift;
    push @{ $self->{_members} }, $member;
}

1;
