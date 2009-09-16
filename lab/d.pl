use YAML;
use Data::Dumper;


open my $fh, "<", "Definitions.yml";
my $txt = do { local $/; <$fh> };
close $fh;

my $def_ref = Load($txt);

print Dumper($def_ref);


