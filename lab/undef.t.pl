

@a = ( 0, 1, 2);
%hash = ( nm, name, end, endereco );


foreach (@a) {
    print "a: $_\n";
}

foreach (sort keys %hash) {
    print "hash: $_  $hash{$_}\n";
}

printf "defined a: %d\n", defined( $a[2] );

printf "defined nm: %d\n", defined( $hash{cep} );
