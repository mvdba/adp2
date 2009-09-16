# $Id$
#
svn_rcsid() {

    =begin sample
    svn log adpmaker.pl | perl -n -e 'print if /^r\d+ [|]/;'

    r594 | marcus.ferreira | 2006-10-04 18:18:26 -0300 (Wed, 04 Oct 2006) | 1 line
    r551 | marcus.ferreira | 2006-10-04 13:36:13 -0300 (Wed, 04 Oct 2006) | 1 line
    r540 | marcus.ferreira | 2006-10-04 11:49:06 -0300 (Wed, 04 Oct 2006) | 2 lines
    r537 | marcus.ferreira | 2006-10-04 11:38:41 -0300 (Wed, 04 Oct 2006) | 5 lines
    =end sample

    =cut

sub get_rcsid {
    my $file = shift;

    unless( -f $file ) {
        carp "Cannot find: $file - $!" ;
        return 0;
    }

    my ($rev, $author, $date, $qty, $comment);
    while( <DATA> ) {
        next if /^#/;
        next if /^\s*$/;
        next if /^-{40,}/;      # at least 40

        chomp;
        s{^\s*|\s*$}{}g;

        if( m{r \d+ [ ][|][ ]}x ) {
            ($rev, $author, $date, $qty) = split ' \| ' => $_;
            $rev =~ s{r(\d+)       }{$1}x;
            $qty =~ s{ (\d+)[ ]line[s]?}{$1}x;

#           COMMENT:
#           while( <DATA> ) {
#               $comment .= $_ if( $. >= $. +2 && $. <= $. + $qty + 1 );
#               last COMMENT if $. > $. + $qty;
#           }

            print "[", join( '] [', $rev, $author, $date, $qty), "]\n";
            print "comment: ",$. + 2 ," ", $. + 1 + $qty, "\n";
        }
        else {
            printf "%3d : %s\n", $., $_;
        }
    }
    return 1;

}

svn_info() {

my ($path
        0   => ['name'      =>  'Path'                  ],
        1   => ['url'       =>  'Name'                  ],
        2   => ['reproot'   =>  'URL'                   ],
        3   => ['repurl'    =>  'Repository Root'       ],
        4   => ['repuuid'   =>  'Repository UUID'       ],
        5   => ['reprev'    =>  'Revision'              ],
        6   => ['node'      =>  'Node Kind'             ],
        7   => ['schedule'  =>  'Schedule'              ],
        8   => ['author'    =>  'Last Changed Author'   ],
        9   => ['rev'       =>  'Last Changed Rev'      ],
        10  => ['date'      =>  'Last Changed Date'     ],
        11  => ['updated'   =>  'Text Last Updated'     ],
        12  => ['checksum'  =>  'Checksum'              ],
   ) = svn_info( 'adpmake/adpmaker.pl');

    return scalar: $rev
    return array: @a;

= begin sample
    Path: adpmake\adpmaker.pl
    Name: adpmaker.pl
    URL: http://localhost:8080/repos/salto/trunk/atg/adpmake/adpmaker.pl
    Repository Root: http://localhost:8080/repos
    Repository UUID: 668e902b-d23d-45e4-8677-41cba24a12b6
    Revision: 4131
    Node Kind: file
    Schedule: normal
    Last Changed Author: marcus.ferreira
    Last Changed Rev: 4131
    Last Changed Date: 2006-11-17 19:45:04 -0200 (Fri, 17 Nov 2006)
    Text Last Updated: 2006-11-17 19:49:28 -0200 (Fri, 17 Nov 2006)
    Checksum: fe879c5666703568a0c0b6a7a63b2328
= end sample

= cut

}
