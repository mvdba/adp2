#!/usr/bin/perl
# $Id: adpmaker.oldsubs.pl 4772 2006-11-27 22:58:11Z marcus.ferreira $
#

sub testvar {
    foreach my $ext (@FileExt) {
        printf "%10s %-30s %20s %s .\n"
                                , $ext
                                , $Object{$ext}
                                , $DestDir{$ext}
                                , $ExecCmd{$ext}
                                ;
    }
};

sub show_Object {
    foreach my $file (sort keys %Object) {
        printf "%-30s %d %10s len: %2s tab: %-6s hdr: %-6s \n"
                        , $file
                        , $Object{$file}->{'bin'} || 0
                        , $Object{$file}->{'ext'} || ''
                        , $Object{$file}->{'len'} || ''
                        , $Object{$file}->{'tab'} || ''
                        , $Object{$file}->{'hdr'} || ''
                        ;
    }
};

sub mk_dir {
    my $path = shift;
    my $dir  = '';

    foreach my $d (split "/", $path ) {
        $dir .= "$d/";
        unless( -d $dir ) {
            print "Criando $dir ...\n";
            mkdir $dir or die "Cannot create dir $dir: $!";
        };
    };
    return;
};

sub dbinfo {
    my $DB_FILE_INFO   = "../dbinfo.obj_ver.adpmk.pl";

    print <<"EOF";

DB Information
--------------
    Source : $DB_FILE_INFO
EOF
    #eval {
        # svn update $DB_FILE_INFO or die "Cannot update $DB_FILE_INFO: $!";
    #};
    eval {
        require $DB_FILE_INFO;
    } or die "Cannot fetch db information: $!";

    %ObjectVersion = get_objver();
    print "    Info   : set ";
    print scalar( (keys %ObjectVersion) ), " file(s). \n\n";

#    my $i=0;
#    foreach ( sort keys %ObjectVersion ) {
#        printf "    %30s : %-10s\n", $_, $ObjectVersion{$_};
#        $i++;
#    }

};


sub ins_objects {
    my ($pname, $objid, $objname, $objver );
    my ($file, $ver, $line);

#   $cmd = "cat ./1.txt";
#   print "cmd: $cmd\n";
#   use FindBin qw($RealBin);
#   $cmd = "/usr/local/bin/pex.pl -p $Patch ";
#   my $argv = join " " => @Obj4Patch;
#   print "cmd: $cmd $argv \n\n" ; exit 99;
#   my @output = `$cmd $argv `; print "$!\n";

#   my @output = `$cmd `; print "$!\n";
#    die "Cannot exec $cmd: $!" if( $! );

    open my $cmd, "<", "1.txt" or die "Cannot open 1.txt: $!";
    #foreach my $line (@output) {
    while( <$cmd> ) {
        $line = $_;
        #print $line;
        next unless $line =~ /^-- RES/;

        chomp $line;
        #print ">>> ",$line," <<<\n";

        #print "$_\n" foreach (split /\s+/, $line);
        (undef, undef, $pname, $objid, $objname, $objver ) = split /\s+/ => $line;
        #print "name: $objname , ver $objver \n";

        (undef, $file) = split /:/ => $objname;
        (undef, $ver ) = split /:/ => $objver;
        #print "$ver - $file \n";

        $Object{$file}->{'ver'} = $ver;
    }
    close $cmd or die "Cannot close 1.txt: $!";
    return;
}

1;
