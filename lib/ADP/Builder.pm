package ADP::Builder;

# $Id$

use strict;
use Carp ();

our $VERSION = sprintf "%d.%02d.%d ", q{0.01} =~ /(\d+)/g, q$Revision: 1 $ =~ /(\d+)/g;
our $errstr  = '';

use FindBin qw($Bin);
use lib "$Bin/..";
use lib "$Bin";

use ADP::Builder::Definitions;
use ADP::Builder::File;
use ADP::Builder::Generators;

#####################################################################
# Class variables

my @_Members = ();
my $_Debugging = 0;

#####################################################################
# Main Interface Methods

# Constructor
sub new {
    my $class = shift;
    return bless {}, $class;
}

# Methods
sub add {
    my $self = shift;
    my $args = shift;

    my $member = ADP::Builder::File->new( $args );
    push @_Members, $member;
    return;
}

sub file_count {
    return scalar @_Members ;
}

sub file_details {
    my $self = shift;
    my $attr = shift;

    $_Members[0]->get( $attr );
}

sub members {
    my @list;
    foreach my $m (@_Members) {
        push @list, $m->name();
    }
    return @list;
}

sub debug {
    # file:///c:/doc/programming.perl/perldoc-5.8.8/perltoot.html#Debugging-Methods
    my $self = shift;
    Carp::confess "usage: thing->debug(level)"    unless @_ == 1;

    my $level = shift;
    if (ref($self))  {
        $self->{"_DEBUG"} = $level; # just myself
    } else {
        $_Debugging       = $level; # whole class
    }
}

sub DESTROY {
    my $self = shift;
    if ($_Debugging || $self->{"_DEBUG"}) {
        Carp::carp "Destroying $self " . $self->name;
    }
    # -- ${ $self->{"_CENSUS"} };
}

1;
