#!perl
# $Id$
#

use strict;
use warnings;
use ADPatch::Maker;

our @Files;

my $patch = ADPatch::Maker->new('ar400-1');

$patch->credentials( { project  => 'salto'
                     , username => 'marcus.ferreira'
                     , password => 'tempo'
                     }
                   );
foreach my $file (@Files) {
    $patch->add_file( $file );
}

my $r = $patch->create();

if( $patch->is_valid() ) {
    $patch->write_to_file( {name => 'test', compress => 'zip'} );
    $patch->summary();
}
else {
    print "Error creating patch file\n";
    print "Check your summary for details\n";
    $patch->summary();
}

print <<DISPLAY;

    Product      [ar]               : $patch->prd
    Gap          [236d]             : $patch->gap
    Version      [1]                : $patch->gap_ver
    Patch_Name   [ar236d-1]         : $patch->name
    Patch_File   [115mdbar236d_001] : $patch->file_name
    Patch_Driver[u115mdbar236d_001] : $patch->driver

DISPLAY

#########
#
# Class::Struct

$patch->Member{'1.txt'}->ext()
$patch->Member{'1.txt'}->is_bin()


