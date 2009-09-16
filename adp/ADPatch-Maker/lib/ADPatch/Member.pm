#
# $Id$
#

package ADPatch::Member;

use strict;
use warnings;
use Class::Std;

use Carp;
use File::Basename;

use ADPatch::Definitions;

our $VERSION = '0.01';

{
    # Public Attributes
    my %filename_of :ATTR( init_arg => 'file', get => 'filename' );
    my %basename_of :ATTR( get => 'basename'  );
    my %dirname_of  :ATTR( get => 'dirname'   );
    my %ext_of      :ATTR( get => 'ext'       );
    my %ver_of      :ATTR;

    # Private Attributes
    my %text_of     :ATTR;
    my %atrib_of    :ATTR;
    my $def;
    
    
    # Constructor takes pathname
    sub BUILD {
        my ($self, $ident, $arg_ref) = @_;
        
        my $file = $arg_ref->{file};
        die "Member MUST be a file" unless -f $file;

        # Patch Member definitions/details
        $def         = ADPatch::Definitions->new();
        my @suffixes = $def->extensions();

        # initialize patch name components
        my ($f, $d, $e) = fileparse( $file, @suffixes );
        $basename_of  {$ident}  = $f . $e;
        $dirname_of   {$ident}  = $d;
        $ext_of       {$ident}  = $e;
        
                    
        # slurp it
        open my $fh, "<", $file  or die "Member: cannot open file - $!";
        $text_of{$ident} = do { local $/; <$fh> };
        close $fh                or die "Member: cannot close file - $!";                

        # Populate file attributes
        if(-B $file) {  # Binary
            $atrib_of{$ident} = {
                bin => 1, tab => 0  , dos => 0  
            };
        }
        else {          # Text
            my $tab = $text_of{$ident} =~ m{\t} ? 1 : 0;
            my $dos = $text_of{$ident} =~ m{\r} ? 1 : 0;
            $atrib_of{$ident} = {
                bin => 0, tab => $tab, dos => $dos,
            };
        }
        $atrib_of{$ident}{hdr} = '$Hdr';
        $atrib_of{$ident}{cnv} = 0;     # Text files: converted
        
    }

    sub patch_it {
        my ($self) = @_;
        my (%p, $hdr, $len_hdr);
        
        my $file = $self->get_basename();
        
        # Patterns to look for
        $p{txt}      = qr{ ( [\$] Header .* [\$] ) }x;
        $p{bin}->[0] = qr{ ( [\$] Header: \s* $file .* [\$] [_| ]* ) }x;
        $p{bin}->[1] = qr{ ( [\$] Header: \s* %f% \s* %v% \s* %d% \s* %u% \s* ship \s* [\$] [_| ]* ) }x;
        $p{bin}->[2] = qr{ ( [\$] Header: .* [\$] \s* ) }x;
        
        # Header line to write
        $hdr =  "\$Header: " 
                . $self->get_basename() . " - "
                . substr($self->get_dirname(),0,15)  . " - "
                . scalar localtime()
                . ' $'
                ;
        $len_hdr = length $hdr;
       
        # save typing
        my $ref_text = \$text_of{ident $self} ;

        # Text file
        if( ! $atrib_of{ident $self}{bin} ) {
            # print "File: Text\n";
            $atrib_of{ident $self}{hdr} =       # count how many.....  
                $$ref_text =~ s/$p{txt}/$hdr/g ;
                
            if( $atrib_of{ident $self}{dos} ){        # Converted
                $$ref_text =~ s/\r//g    ;
                $atrib_of{ident $self}{cnv} = 1;
                $atrib_of{ident $self}{dos} = 0;
            }
                        
            if( $atrib_of{ident $self}{tab} ){
                $$ref_text =~ s/\t/    /g;          # 1 tab = 4 ' '
                $atrib_of{ident $self}{cnv} = 1;    # Converted
                $atrib_of{ident $self}{tab} = 0;
            }
                        
        }
        
        # Binary file
        if( $atrib_of{ident $self}{bin} ) {
          # print "File: Binary\n";
          
            my ($match, $len, $new_txt, @store_for, $kount);
            for my $i ( 0..1 ) {
              # print "Searching pattern $i\n";
                
                # locate file text at the beginning
                pos $text_of{ident $self} = 0;
                $kount = 0;
                
                BINARY: 
                while (pos $$ref_text < length $$ref_text ) { # walk through text
                    
                    if( $$ref_text =~ m/ $p{bin}->[$i] /gcx ) {
                        # match! print "Match!\n";
                        $match = $1; $len = length $match;

                        # fits inside: complements to keep size
                        # else       : truncate to keep size
                        if($len_hdr<=$len) { $new_txt = $hdr . "_" x ($len-$len_hdr);       }
                        else               { $new_txt = substr($hdr, 0, $len-4) .'## $'; }
                        
                        # store replacement coordinates
                        $store_for[ $kount ]->{pos} = (pos $text_of{ident $self}) - $len;
                        $store_for[ $kount ]->{len} = $len;
                        $store_for[ $kount ]->{txt} = $new_txt;
                        $kount++;
                        $atrib_of{ident $self}{hdr} = $kount;
                        
                        printf "  loop %d: %d\n  %4d [%s]\n  %4d [%s]\n"
                               , $kount, pos $$ref_text, $len, $match, $len_hdr, $new_txt 
                        if (0) ;
                    }
                    else {
                        last BINARY;
                    } # end if match
                    
                } # end while BINARY
                
                # Replace all '$Header's found -- !!!!!!!
                foreach my $i ( 0..$kount -1 ) {
                    substr( $$ref_text
                          , $store_for[$i]->{pos}
                          , $store_for[$i]->{len}
                          ) = $store_for[$i]->{txt};
                }
            } # end for ptt
        } # end Binary
        return $atrib_of{ident $self}{hdr};    
    }

    sub dump {
        my $self = shift;
        my $dest = shift || $self->get_basename();
        
        open my $out, ">", $dest or die "Member: Cannot open $dest: $!";
        print {$out} $text_of{ident $self};
        close $out               or die "Member: Cannot close $dest: $!";
        
        return ;
    
    }
    
    sub get_atrib{
        my ($self) = @_;
        return $atrib_of{ident $self};
    }
    
    sub get_ver {
        return 0;
    }
    sub get_descr {
        my ($self) = @_;
        return $def->get_def_descr( $ext_of{ident $self} );
    }
    sub get_dir {
        my ($self) = @_;
        return $def->get_def_dir  ( $ext_of{ident $self} );
    }
    sub get_cmd {
        my ($self) = @_;
        return $def->get_def_cmd  ( $ext_of{ident $self} );
    }

}

1;

__END__

=head1 NAME

ADPatch::Member - Member class for ADPatch::Maker itens.

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

Item details...

Perhaps a little code snippet.

    use ADPatch::Member;

    my $foo = ADPatch::Member->new();
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 FUNCTIONS

=head2 x

=cut

sub x {
}

=head2 y

=cut

sub y {
}

=head1 AUTHOR

Marcus Vinicius Ferreira, C<< <ferreira.mv at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-adpatch-member at rt.cpan.org>, or through the web interface at
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

1; # End of ADPatch::Member
