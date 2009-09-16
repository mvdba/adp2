#!perl

use Test::More tests => 10;

use lib './lib';
use ADPatch::Maker;


my ($p,$f,$r);

diag( "Testing ADPatch::Maker $ADPatch::Maker::VERSION, Perl $], $^X" );

$p = ADPatch::Maker->new( { 'name' => 'ar236g-1' } );
    ok( defined $p                      , "'ar236g-1'"      );
    isa_ok( $p, 'ADPatch::Maker');

$f = $p->add_file( '1.txt' ); is( $f    , 1 , "     Added $f" ); # 3
$f = $p->add_file( '2.txt' ); is( $f    , 2 , "     Added $f" );
$f = $p->add_file( '3.txt' ); is( $f    , 3 , "     Added $f" );
$f = $p->add_file( '4.txt' ); is( $f    , 4 , "     Added $f" );
$f = $p->add_file( '5.txt' ); is( $f    , 5 , "     Added $f" );

$f = join ("," => $p->get_files()); is( $f , '1.txt,2.txt,3.txt,4.txt,5.txt', "     get_files() returned list: $f");
$f = $p->count_members()          ; is( $f , 5 , "     count_members() counts.");

$r = $p->display(); ok( defined $r ,  "    display.");

