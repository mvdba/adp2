#!perl

use Test::More tests => 32;

use lib "./lib";
use ADPatch::Member;
use File::Copy;

diag( "File members" );

my %t = (
        ""                  => "Invalid name",
        "/tmp"              => "Dir only",
        "/tmp/"             => "Dir only/",
        "/tmp/1.txt"        => "Invalid prd",
        "/tmp/1.txt/"       => "Invalid prd",
        "/tmp/txt.1.txt"    => "Text File",
        "/tmp/bin.1.bin"    => "Binary",
    );

my ($r, $atrib);
my $f = ADPatch::Member->new( {file=>$0} ); # This script
    isa_ok( $f, "ADPatch::Member");

# Text
copy( $0, "/tmp/1.txt" );
    $f = ADPatch::Member->new( {file => "/tmp/1.txt"} );
    $r = $f->get_filename() ;    is( $r, "/tmp/1.txt"  , "    filename \t- $r");
    $r = $f->get_dirname()  ;    is( $r, "/tmp/"       , "    dirname  \t- $r");
    $r = $f->get_basename() ;    is( $r, "1.txt"       , "    basename \t- $r");
    $r = $f->get_ext()      ;    is( $r, "txt"         , "    extension\t- $r"); # 5
    $r = $f->get_descr()    ;    is( $r, "Text File"   , "    ext descr\t- $r");
    $r = $f->get_dir()      ;    ok( $r,                 "    ext dir  \t- $r");
    $r = substr($f->get_cmd(),0,3) ;    ok( $r,                 "    ext cmd  \t- $r");

    unlink "/tmp/1.txt";

copy( $0, "/tmp/1.sql" );
    $f = ADPatch::Member->new( {file => "/tmp/1.sql"} );
    $r = $f->get_filename() ;    is( $r, "/tmp/1.sql"  , "    filename \t- $r");
    $r = $f->get_dirname()  ;    is( $r, "/tmp/"       , "    dirname  \t- $r");
    $r = $f->get_basename() ;    is( $r, "1.sql"       , "    basename \t- $r");
    $r = $f->get_ext()      ;    is( $r, "sql"         , "    extension\t- $r");
    $r = $f->get_descr()    ;    is( $r, "SQL Script"  , "    ext descr\t- $r");
    $r = $f->get_dir()      ;    ok( $r,                 "    ext dir  \t- $r");
    $r = substr($f->get_cmd(),0,3) ;    ok( $r,                 "    ext cmd  \t- $r");

diag("Member 'atributes': No tab, Unix");
    $ref_atrib = $f->get_atrib();           ok( $r , "    got attributes.");
    is( $ref_atrib->{bin}, 0    , "    bin: $ref_atrib->{bin}" );
    is( $ref_atrib->{tab}, 0    , "    tab: $ref_atrib->{tab}" );
    is( $ref_atrib->{dos}, 0    , "    dos: $ref_atrib->{dos}" );
    is( $ref_atrib->{hdr},'$Hdr', "    hdr: $ref_atrib->{hdr}" );

    unlink "/tmp/1.sql";

diag("Tab dos");
    open my $fh, ">", "/tmp/tabdos.txt" or die "Cannot open tabdos.txt : $!";
    print $fh "        \t     \r\n   \n \r   ";
    close $fh or die "cannot close tabdos.txt: $!";

    $f = ADPatch::Member->new( {file => "/tmp/tabdos.txt"} );
    $ref_atrib = $f->get_atrib();           ok( $r , "    got attributes.");
    is( $ref_atrib->{bin}, 0    , "    bin: $ref_atrib->{bin}" );
    is( $ref_atrib->{tab}, 1    , "    tab: $ref_atrib->{tab}" );
    is( $ref_atrib->{dos}, 1    , "    dos: $ref_atrib->{dos}" );

    unlink "/tmp/tabdos.txt";

diag("Tab unix");
    open my $fh, ">", "/tmp/tabunix.txt" or die "Cannot open tabunix.txt : $!";
    print $fh "        \t     \n   \n    ";
    close $fh or die "cannot close tabunix.txt: $!";

    $f = ADPatch::Member->new( {file => "/tmp/tabunix.txt"} );
    $ref_atrib = $f->get_atrib();           ok( $r , "    got attributes.");
    is( $ref_atrib->{bin}, 0    , "    bin: $ref_atrib->{bin}" );
    is( $ref_atrib->{tab}, 1    , "    tab: $ref_atrib->{tab}" );
    is( $ref_atrib->{dos}, 0    , "    dos: $ref_atrib->{dos}" );

    unlink "/tmp/tabunix.txt";

diag("Binary");
    open my $fh, ">", "/tmp/bin.1.bin" or die "Cannot open bin.1.bin : $!";
    print $fh map{ pack('s', $_) } ( 1 .. 60 );
    close $fh or die "cannot close bin.1.bin: $!";

    $f = ADPatch::Member->new( {file => "/tmp/bin.1.bin"} );
    $ref_atrib = $f->get_atrib();           ok( $r , "    got attributes.");
    is( $ref_atrib->{bin}, 1    , "    bin: $ref_atrib->{bin}" );
    is( $ref_atrib->{tab}, 0    , "    tab: $ref_atrib->{tab}" );
    is( $ref_atrib->{dos}, 0    , "    dos: $ref_atrib->{dos}" );

    unlink "/tmp/bin.1.bin";

# use Data::Dumper; print Dumper $ref_atrib;

