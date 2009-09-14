#!perl

# Load test the Archive::Builder module

use strict;
BEGIN {
	$|  = 1;
	$^W = 1;
}

use Test::More 'no_plan';

# Check their perl version
BEGIN {
	ok( $] >= 5.005, 'Your perl is new enough' );
}

# Load all of the classes
use FindBin qw($Bin);
use lib "$Bin/../lib";
use lib "$Bin";

use_ok( 'ADP::Builder'             );
use_ok( 'ADP::Builder::Definitions');
use_ok( 'ADP::Builder::File'       );
use_ok( 'ADP::Builder::Generators' );

exit(0);
