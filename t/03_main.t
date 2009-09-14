
use Test::More 'no_plan';

use FindBin qw($Bin);
use lib "$Bin/../lib";
use lib "$Bin";

use ADP::Builder ();

# Execute the tests
my $p = ADP::Builder->new();
my $count = $p->file_count();
is( $count, 0, 'initial count must be zero');

$p->add( {NAME=>'m1'} ); $count = $p->file_count();
is( $count, 1, "... add 1 member ok.");
$p->add( {NAME=>'m2'} ); $count = $p->file_count();
is( $count, 2, "... add 2 members ok.");
$p->add( {NAME=>'m3'} ); $count = $p->file_count();
is( $count, 3, "... add 3 members ok.");

my @list = $p->members();
is( $list[0], 'm1', '... member 1 ok.');
is( $list[1], 'm2', '... member 2 ok.');
is( $list[2], 'm3', '... member 3 ok.');

my $x;
foreach my $attr (qw/ name path rev author date /) {
    $x = $p->file_details( uc $attr );
    ok( $x, "attr $attr = $x" );
}
