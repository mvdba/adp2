#!perl -T

use Test::More tests => 7;

use lib './lib';

BEGIN {
	use_ok( 'ADPatch::Maker' );
	use_ok( 'ADPatch::Member' );
	use_ok( 'ADPatch::Member::Forms' );
	use_ok( 'ADPatch::DB' );
	use_ok( 'ADPatch::Utils' );
	use_ok( 'ADPatch::CGI' );
	use_ok( 'ADPatch::Build' );
}

diag( "Testing ADPatch::Maker $ADPatch::Maker::VERSION, Perl $], $^X" );
