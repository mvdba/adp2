#!/usr/bin/perl -n
# $Id: fmt.tsb2hash.pl 4640 2006-11-24 20:15:16Z marcus.ferreira $
#
# format: 2 columns tsb -> hash code
#

next if /^#/;
next if /^\s*$/;
# exit if $. > 10;

($obj,$ver) = split;
$obj = "'".$obj."'";

printf "    %-36s => %3d ,\n", $obj, $ver;

