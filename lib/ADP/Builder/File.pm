package ADP::Builder::File;

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
    my $args  = shift;

    my %data =  ( NAME      => $args->{NAME}
                , PATH      => "trunk/proj/" . $args->{NAME}
                , REV       => "1.1.11"
                , DATE      => scalar localtime
                , AUTHOR    => "mvf"
                );
    # recipe 13.1
    # my %extra = @_;
    # @$self{keys %extra} = values %extra;

    return bless \%data, $class;
}

# Methods
sub name {
    my $self = shift;
    return $self->{NAME};
}
sub get {
    my $self = shift;
    my $data = shift;
    return $self->{ uc $data } || 'null' ;
}

1;
