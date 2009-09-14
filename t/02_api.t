#!/usr/bin/perl

# Basic first pass API testing for ADP::Builder::Fill

use strict;
BEGIN {
	$|  = 1;
	$^W = 1;
}

# Load the API to test
use FindBin qw($Bin);
use lib "$Bin/../lib";
use lib "$Bin";

use ADP::Builder ();

# Execute the tests
use Test::More 'no_plan';
use Test::ClassAPI;

# Ignore imported functions
$Test::ClassAPI::IGNORE{refaddr} = 1;

# Execute the tests
Test::ClassAPI->execute('complete', 'collisions');
exit(0);

__DATA__

ADP::Builder=class
ADP::Builder::Definitions=class
ADP::Builder::File=class
ADP::Builder::Generators=class

[ADP::Builder]
new=method
add=method
file_count=method
members=method
file_details=method
# importe by 'use Carp ();'
debug=method

[ADP::Builder::Definitions]
new=method
get=method

[ADP::Builder::File]
new=method
get=method
name=method

[ADP::Builder::Generators]
new=method
get=method
