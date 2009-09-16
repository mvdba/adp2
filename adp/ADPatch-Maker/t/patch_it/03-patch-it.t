#!perl

use Test::More tests => 23;

use FindBin qw($Bin $Script $RealBin $RealScript);

# print "Bin $Bin \n";
# print "Script $Script \n";
# print "RealBin $RealBin \n";
# print "RealScript $RealScript \n";

use lib "$Bin/../../lib";
use ADPatch::Member;

my %results_for = (
    'MDB.fmb'     => 2,
    'MDB.rdf'     => 1,
    'MDB.sql'     => 1,
    'MDB_CCR.ldt' => 1,
    'MDB_PKS.pls' => 1,
    'MDB_PKB.pls' => 2,
);

diag("Patching and dumping files");

    foreach my $file (sort keys %results_for) {
      # print "file: $file\n"; next;
        my $f = ADPatch::Member->new( {file => "$Bin/" . $file} );

        my $r = $f->patch_it();
        is( $r, $results_for{$file}, "match(es): $r");

        $f->dump( "$Bin/patched." . $_ );
        ok( -f "$Bin/patched." . $_ , "File: patched.$_");
    }

    unlink "$Bin/patched.$_" foreach(@f);

diag("Converting");
        my $f = ADPatch::Member->new( {file => "$Bin/" . 'tabdos.sql'} );
        $ref_atrib = $f->get_atrib();           ok( $ref_atrib , "    got attributes.");

        is( $ref_atrib->{bin}, 0    , "    bin: $ref_atrib->{bin}" );
        is( $ref_atrib->{tab}, 1    , "    tab: $ref_atrib->{tab}" );
        is( $ref_atrib->{dos}, 1    , "    dos: $ref_atrib->{dos}" );
        is( $ref_atrib->{cnv}, 0    , "    cnv: $ref_atrib->{cnv}" );

        my $r = $f->patch_it();
        is( $r, 5, "patched.");

        is( $ref_atrib->{tab}, 0    , "    tab: $ref_atrib->{tab}" );
        is( $ref_atrib->{dos}, 0    , "    dos: $ref_atrib->{dos}" );
        is( $ref_atrib->{cnv}, 1    , "    cnv: $ref_atrib->{cnv}" );

        $f->dump( "$Bin/patched.notabunix.sql" );
        open my $fh, "<", "$Bin/patched.notabunix.sql" or die "Cannot open: $!";
        my $text = do { local $/; <$fh> };
        close $fh or die "Cannot close: $!";

        ok( $text !~ /\r/, "Converted: file is not DOS.");
        ok( $text !~ /\t/, "Converted: file has no TABs.");

diag( "Testing ADPatch::Maker $ADPatch::Maker::VERSION, Perl $], $^X" );

