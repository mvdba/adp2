package ADP::Builder::Generators;

# $Id$

use strict;

our $VERSION = sprintf "%d.%02d.%d ", q{0.01} =~ /(\d+)/g, q$Revision: 1 $ =~ /(\d+)/g;
our $errstr  = '';


use FindBin qw($Bin);
use lib "$Bin/../..";
use lib "$Bin";

# use ADP::Builder;

#####################################################################
# Class variables

my %_def_for;

#####################################################################
# Main Interface Methods

# Constructor
sub new {
    my $class = shift;
    return bless {}, $class;
}

# Methods
sub get {
    my $self = shift;
    my $data = shift;
    return $_def_for{ $data } || 'null' ;
}

1;

