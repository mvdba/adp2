package ADPatch::Build;

use warnings;
use strict;

1;

__END__

=head1 NAME

ADPatch::Build - parser for build.txt.

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

Parse 'build.txt';

Perhaps a little code snippet.

    use ADPatch::Build;

    my $foo = ADPatch::Build->new();
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 FUNCTIONS

=head2 open_build

=cut

sub open_build {
}

=head2 x

=cut

sub parse {
}

=head1 AUTHOR

Marcus Vinicius Ferreira, C<< <ferreira.mv at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-adpatch-build at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=ADPatch-Maker>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc ADPatch::Maker

You can also look for information at:

=over 4

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/ADPatch-Maker>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/ADPatch-Maker>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=ADPatch-Maker>

=item * Search CPAN

L<http://search.cpan.org/dist/ADPatch-Maker>

=back

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2007 Marcus Vinicius Ferreira, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of ADPatch::Build
