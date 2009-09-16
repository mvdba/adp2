#!perl
# $Id$

use Test::More tests => 175;

use lib "./lib";
use ADPatch::Definitions;

diag("Getting definitions");
    my $def = ADPatch::Definitions->new();
        isa_ok( $def, "ADPatch::Definitions");

        my $qtd_ext = $def->extensions(); # scalar
        ok( $qtd_ext > 1 , "I have $qtd_ext extensions.");

    my ($descr, $dir, $cmd);
    my @definitions = $def->extensions(); # array context
    my $r = join "," => @definitions    ; like( $r , qr/,/ , "    extensions(): $r" );


    foreach my $ext (sort @definitions) {
        ok( defined $ext, "Extension: $ext");

        $descr = $def->get_def_descr($ext);   ok( $descr, "    Descr: [$descr]");
        $dir   = $def->get_def_dir($ext);     ok( $dir  , "      Dir is ok.");
        $cmd   = $def->get_def_cmd($ext);     ok( $cmd  , "      Cmd is ok.");
    }

exit 0;
