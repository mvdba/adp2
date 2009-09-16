#!perl

use Test::More tests => 46;

use lib './lib';
use ADPatch::Maker;

# my $batch = MARC::Batch->new( 'USMARC', @files );
# isa_ok( $batch, "MARC::Batch" );

# is( unlink( $filename ), 1, "Remove $filename" );
# ok( !-e $filename, "Actually gone" );

diag( "Testing ADPatch::Maker $ADPatch::Maker::VERSION, Perl $], $^X" );

diag( "Testing new()." );
my $p = ADPatch::Maker->new( { 'name' => 'ar236-1' } );
    ok( defined $p                      , "'ar236-1'"     );
    isa_ok( $p, 'ADPatch::Maker');
    is( $p->get_name() , 'ar236-1'      , "    get name ok" );
    is( $p->get_prd()  , 'ar'           , "    get prd ok"  );
    is( $p->get_gap()  , '236'          , "    get gap ok"  );
    is( $p->get_ver()  , '1'            , "    get ver ok"  );

diag( "Testing multiple names." );
my $p = ADPatch::Maker->new( { 'name' => 'ar236d-1' }   );
    ok( defined $p                    , "'ar236d-1'"    );
    is( $p->get_prd(), 'ar'           , "    get prd ok"  );
    is( $p->get_gap(), '236d'         , "    get gap ok"  );
    is( $p->get_ver(), '1'            , "    get ver ok"  );

my $p = ADPatch::Maker->new( { 'name' => 'arx236-1' }   );
    ok( defined $p                    , "'arx236-1'"    );
    is( $p->get_prd(), 'ar'           , "    get prd ok"  );
    is( $p->get_gap(), '236'          , "    get gap ok"  );
    is( $p->get_ver(), '1'            , "    get ver ok"  );

my $p = ADPatch::Maker->new( { 'name' => 'arx236d-1' }  );
    ok( defined $p                    , "'arx236d-1'"   );
    is( $p->get_prd(), 'ar'           , "    get prd ok"  );
    is( $p->get_gap(), '236d'         , "    get gap ok"  );
    is( $p->get_ver(), '1'            , "    get ver ok"  );

my $p = ADPatch::Maker->new( { 'name' => 'wip236d-1' }  );
    ok( defined $p                    , "'wip236d-1'"   );
    is( $p->get_prd(), 'wip'          , "    get prd ok"  );
    is( $p->get_gap(), '236d'         , "    get gap ok"  );
    is( $p->get_ver(), '1'            , "    get ver ok"  );

my $p = ADPatch::Maker->new( { 'name' => 'wipx236d-1' } );
    ok( defined $p                    , "'wipx236d-1'"  );
    is( $p->get_prd(), 'wip'          , "    get prd ok"  );
    is( $p->get_gap(), '236d'         , "    get gap ok"  );
    is( $p->get_ver(), '1'            , "    get ver ok"  );

my $p = ADPatch::Maker->new( { 'name' => 'inst236d-1' } );
    ok( defined $p                    , "'inst236-1'"   );
    is( $p->get_prd(), 'inst'         , "    get prd ok"  );
    is( $p->get_gap(), '236d'         , "    get gap ok"  );
    is( $p->get_ver(), '1'            , "    get ver ok"  );

my $p = ADPatch::Maker->new( { 'name' => 'ar236-001' }  );
    ok( defined $p                    , "'ar236-001'"   );
    is( $p->get_prd(), 'ar'           , "    get prd ok"  );
    is( $p->get_gap(), '236'          , "    get gap ok"  );
    is( $p->get_ver(), '1'            , "    get ver ok"  );

my $p = ADPatch::Maker->new( { 'name' => 'ar236-0001' } );
    ok( defined $p                    , "'ar236-0001'"  );
    is( $p->get_prd(), 'ar'           , "    get prd ok"  );
    is( $p->get_gap(), '236'          , "    get gap ok"  );
    is( $p->get_ver(), '1'            , "    get ver ok"  );     #37

my $p;
my %t = (
        'empty'     => 'Invalid name',
        123         => 'No prd',
        123-1       => 'No prd',
        abcde       => 'Invalid prd',
        abcde123    => 'Invalid prd',
        abcde123-1  => 'Invalid prd',
        ar123456-1  => 'Invalid gap',
        ar          => 'No gap',
        ar-1        => 'No gap',
        ar234       => 'No gap ver',
        ar234-1     => 'Valid     ',
    );

my $msg;
for my $name (sort keys %t) {
    $msg  = $t{$name};
    $name = '' if $name = 'empty';
    eval { $p = ADPatch::Maker->new( { 'name' =>  $name } ); };
    ok( !defined $p , "Managed to get error: $msg" );
};


diag( "Testing ADPatch::Maker $ADPatch::Maker::VERSION, Perl $], $^X" );
