#
# $Id$
#

package ADPatch::Maker;

use strict;
use warnings;
use Carp;
use Class::Std;

use ADPatch::Member;

our $VERSION = '0.01';

{
    # Public Attributes
    my %patch_of    :ATTR( init_arg => 'name', get => 'name' );
    my %prd_of      :ATTR( get => 'prd'       );
    my %gap_of      :ATTR( get => 'gap'       );
    my %ver_of      :ATTR( get => 'ver'       );

    # Private Attributes
    my %members_of      :ATTR;
    my %definitions_of  :ATTR;
    
    # Constructor takes patch name like 'ar236g-1'
    sub BUILD {
        my ($self, $ident, $arg_ref) = @_;

        # initialize patch name components
        my %init = _parse( $arg_ref->{name} );
        $prd_of  {$ident}   = $init{prd};
        $gap_of  {$ident}   = $init{gap};
        $ver_of  {$ident}   = $init{ver};
        
        # list of files: members
        $members_of{$ident} = [];
    }

    sub _parse : PRIVATE {
        my $pname = shift;
        my %p;
        
        $pname = lc( $pname ); 
        $pname =~ s/x//; # no 'x'
        $pname =~ m/( [A-Za-z]{2,4} )   # prd: min 2 -> ar
                                        #      max 4 -> inst
                      ( \d{3}\w? )      # gap: 3 num + 1 alpha
                      -                 #  
                      (\d+)             # gap ver: num
                   /x;
        die "ADPatch: Invalid product in patch name "     unless($1);
        die "ADPatch: Invalid gap in patch name "         unless($2);
        die "ADPatch: Invalid gap version in patch name " unless($3);
        
        %p = ( 'prd', $1, 'gap', $2, 'ver', $3 );
        $p{ver} += 0 if defined $3; # to_number
        return %p;
    }
    
    sub add_file {
        my ($self, $file) = @_;

        my $m = ADPatch::Member->new( {file=>$file} );
        push @{ $members_of{ident $self} }, $m;

        return scalar @{ $members_of{ident $self} };
    }
    
    sub get_files {
        my ($self) = @_;
        
        my @f;
        foreach my $file ( @{ $members_of{ident $self} } ) {
            push @f,$file->get_filename();
        } 
        return sort @f;
    }

    sub count_members : NUMERIFY {
        my ($self) = @_;
        return scalar @{ $members_of{ident $self} };
    }
    
    sub display {
        my ($self) = @_;
        
        my $d;
        if (@{ $members_of{ident $self} } == 0) {
            return;
        }
        
        foreach my $f ( @{ $members_of{ident $self} } ){
            $d .= sprintf "%-35s %-22s %10s %-5s %-5s %-6s %-7s\n"
                , $f->get_filename()
                , $f->get_ver()                 || '-1'
                , length $f->get_filename()     || '-'
                , 'tab'                         || '-'
                , 'dos'                         || '-'
                , 'hdr'                         || '-'
                , '$appv' . '.' .  ($f->get_ver() || '0' )
                ;
        }
        return $d;     
    }
      
    
}

1;

__END__;

=head1 NAME

ADPatch::Maker - Oracle Applications ADPatch patch file maker.

=head1 VERSION

Version 0.01

=cut


=head1 SYNOPSIS

Oracle Applications patch files...

Perhaps a little code snippet.

    use ADPatch::Maker;

    my $patch = ADPatch::Maker->new('ar404-1');
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 FUNCTIONS

=head2 new

=cut

sub new {
}

=head2 credentials

=cut

sub credentials {
}

=head1 AUTHOR

Marcus Vinicius Ferreira, C<< <ferreira.mv at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-adpatch-maker at rt.cpan.org>, or through the web interface at
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

1; # End of ADPatch::Maker
