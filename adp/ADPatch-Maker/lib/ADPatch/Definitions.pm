#
# $Id$
#

package ADPatch::Definitions;

our $VERSION   = '0.01';

{
    use strict;
    use warnings;
    
    my $singleton = undef;
    my $definitions = {};
    
    sub new {
        my ($class) = @_;
        
        return $singleton if defined $singleton;
        
        $singleton = bless( $definitions, $class );
        
        return $singleton;
    }
    
    sub extensions {
        my $a_ref = [];
    
        foreach my $ext (sort keys %{$definitions}){
            push @{$a_ref}, $ext;
        }
        return @{$a_ref};
    }
    
    sub get_def_descr {
        my ($self, $ext) = @_;
        return ${$self}{$ext}->[0];
    }
    
    sub get_def_dir {
        my ($self, $ext) = @_;
        return ${$self}{$ext}->[1];
    }
    
    sub get_def_cmd {
        my ($self, $ext) = @_;
        return ${$self}{$ext}->[2];
    }
    
    $definitions = {   # ext => descr, dir, cmd
        'tab'       =>  [ 'Table'                  , 'patch/115/sql', 'sql      %mod% %dir% %file% none none none sqlplus        &phase=tab+1  &un_%mod% &pw_%mod% %%              ' ] ,
        'ttb'       =>  [ 'Temporary Table'        , 'patch/115/sql', 'sql      %mod% %dir% %file% none none none sqlplus        &phase=tab+1  &un_%mod% &pw_%mod%                 ' ] ,
        'con'       =>  [ 'Constraint'             , 'patch/115/sql', 'sql      %mod% %dir% %file% none none none sqlplus        &phase=tab+10 &un_%mod% &pw_%mod% &index_tspace %%' ] ,
        'col'       =>  [ 'Alter Table Column'     , 'patch/115/sql', 'sql      %mod% %dir% %file% none none none sqlplus_single &phase=tbm+1  &un_%mod% &pw_%mod%                 ' ] ,
        'seq'       =>  [ 'Sequence'               , 'patch/115/sql', 'sql      %mod% %dir% %file% none none none sqlplus        &phase=seq+1  &un_%mod% &pw_%mod% %%              ' ] ,
        'ind'       =>  [ 'Index'                  , 'patch/115/sql', 'sql      %mod% %dir% %file% none none none sqlplus        &phase=tbm+3  &un_%mod% &pw_%mod% &index_tspace %%' ] ,
        'grt'       =>  [ 'Grant'                  , 'patch/115/sql', 'sql      %mod% %dir% %file% none none none sqlplus        &phase=os+2   &un_%mod% &pw_%mod% &un_apps %%     ' ] ,
        'syn'       =>  [ 'Synonym'                , 'patch/115/sql', 'sql      %mod% %dir% %file% none none none sqlplus        &phase=os+3   &un_apps &pw_apps &un_%mod% %%      ' ] ,
        'sql'       =>  [ 'SQL Script'             , 'patch/115/sql', 'sql      %mod% %dir% %file% none none none sqlplus        &phase=dat+10 &un_apps &pw_apps                   ' ] ,
        'vw'        =>  [ 'Views'                  , 'patch/115/sql', 'sql      %mod% %dir% %file% none none none sqlplus        &phase=vw     &un_apps &pw_apps %%                ' ] ,
        'ddl'       =>  [ 'Alter DB Objects'       , 'patch/115/sql', 'sql      %mod% %dir% %file% none none none sqlplus        &phase=tbm+1  &un_apps &pw_apps                   ' ] ,
        'PKS.pls'   =>  [ 'Package Specification'  ,     'admin/sql', 'sql      %mod% %dir% %file% none none none package        &phase=pls    &un_apps &pw_apps %%                ' ] ,
        'PKB.pls'   =>  [ 'Package Body'           ,     'admin/sql', 'sql      %mod% %dir% %file% none none none package        &phase=plb    &un_apps &pw_apps %%                ' ] ,
        'trg'       =>  [ 'Trigger'                ,     'admin/sql', 'sql      %mod% %dir% %file% none none none package        &phase=pls    &un_apps &pw_apps                   ' ] ,
        'odf.tab'   =>  [ 'Table    via ODF'       , 'patch/115/sql', 'exec     %mod% %dir% %file%                odf            &phase=tab mode=tables   ' ] ,
        'odf.seq'   =>  [ 'Sequence via ODF'       , 'patch/115/sql', 'exec     %mod% %dir% %file%                odf            &phase=seq mode=sequences' ] ,
        'odf.vw'    =>  [ 'View     via ODF'       , 'patch/115/sql', 'exec     %mod% %dir% %file%                odf            &phase=vw  mode=views    ' ] ,
        'fmb'       =>  [ 'Forms'                  ,      'forms/US', 'genform  %mod% %dir% %file% %%' ] ,
        'rdf'       =>  [ 'Reports'                ,    'reports/US', 'genrep   %mod% %dir% %file% %%' ] ,
        'ogd'       =>  [ 'Graphics'               ,     'graphs/US', 'genogd   %mod% %dir% %file% %%' ] ,
        'pll'       =>  [ 'PLL: Forms'             ,      'resource', 'genfpll  %mod% %dir% %file% %%' ] ,
        'rep.pll'   =>  [ 'PLL: Reports'           ,      'resource', 'genrpll  %mod% %dir% %file% %%' ] ,
        'ogd.pll'   =>  [ 'PLL: Graphics'          ,      'resource', 'gengpll  %mod% %dir% %file% %%' ] ,
        'mnu'       =>  [ 'Menus'                  ,  'admin/import', 'genmenu  %mod% %dir% %file% %%' ] ,
        'msg'       =>  [ 'Messages'               ,  'admin/import', 'genmesg  %mod% %dir% %file% %%' ] ,
        'wft'       =>  [ 'Workflow'               ,  'admin/import', 'exec fnd bin WFLOAD  bin &phase=dat+10 &ui_apps 0 Y FORCE                                        @%mod%:%dir%:%file%   ' ] ,
        'MSG.ldt'   =>  [ 'FND Message'            ,  'admin/import', 'exec fnd bin FNDLOAD bin &phase=dat+10 &ui_apps 0 Y UPLOAD @FND:patch/115/import/afmdmsg.lct     @%mod%:%dir%:%file%   ' ] ,
        'MNU.ldt'   =>  [ 'FND Menu'               ,  'admin/import', 'exec fnd bin FNDLOAD bin &phase=dat+10 &ui_apps 0 Y UPLOAD @FND:patch/115/import/afsload.lct     @%mod%:%dir%:%file%   ' ] ,
        'DFF.ldt'   =>  [ 'FND Flexfield'          ,  'admin/import', 'exec fnd bin FNDLOAD bin &phase=dat+11 &ui_apps 0 Y UPLOAD @FND:patch/115/import/afffload.lct    @%mod%:%dir%:%file%   ' ] ,
        'LKP.ldt'   =>  [ 'FND Lookup'             ,  'admin/import', 'exec fnd bin FNDLOAD bin &phase=dat+11 &ui_apps 0 Y UPLOAD @FND:patch/115/import/aflvmlu.lct     @%mod%:%dir%:%file%   ' ] ,
        'PRF.ldt'   =>  [ 'FND Profile'            ,  'admin/import', 'exec fnd bin FNDLOAD bin &phase=dat+11 &ui_apps 0 Y UPLOAD @FND:patch/115/import/afscprof.lct    @%mod%:%dir%:%file%   ' ] ,
        'VST.ldt'   =>  [ 'FND Value Set'          ,  'admin/import', 'exec fnd bin FNDLOAD bin &phase=dat+11 &ui_apps 0 Y UPLOAD @FND:patch/115/import/afffload.lct    @%mod%:%dir%:%file%   ' ] ,
        'CCR.ldt'   =>  [ 'FND Concurrent'         ,  'admin/import', 'exec fnd bin FNDLOAD bin &phase=dat+12 &ui_apps 0 Y UPLOAD @FND:patch/115/import/afcpprog.lct    @%mod%:%dir%:%file%   ' ] ,
        'RG.ldt'    =>  [ 'FND Request Group'      ,  'admin/import', 'exec fnd bin FNDLOAD bin &phase=dat+14 &ui_apps 0 Y UPLOAD @FND:patch/115/import/afcpreqg.lct    @%mod%:%dir%:%file% %%' ] ,
        'RQG.ldt'   =>  [ 'FND Request Group'      ,  'admin/import', 'exec fnd bin FNDLOAD bin &phase=dat+14 &ui_apps 0 Y UPLOAD @FND:patch/115/import/afcpreqg.lct    @%mod%:%dir%:%file% %%' ] ,
        'RQS.ldt'   =>  [ 'FND Request Set'        ,  'admin/import', 'exec fnd bin FNDLOAD bin &phase=dat+14 &ui_apps 0 Y UPLOAD @FND:patch/115/import/afcprset.lct    @%mod%:%dir%:%file% %%' ] ,
        'FP.ldt'    =>  [ 'Forms Personalization'  ,  'admin/import', 'exec fnd bin FNDLOAD bin &phase=dat+11 &ui_apps 0 Y UPLOAD @FND:patch/115/import/affrmcus.lct    @%mod%:%dir%:%file%   ' ] ,
        'drv'       =>  [ 'Applications Driver'    ,  'admin/driver', '.' ] ,
        'txt'       =>  [ 'Text File'              ,             '.', '.' ] ,
        'doc'       =>  [ 'Document'               ,             '.', '.' ] ,
        'rdf'       =>  [ 'Document'               ,             '.', '.' ] ,
        'pdf'       =>  [ 'Document'               ,             '.', '.' ] ,
        'java'      =>  [ 'Java'                   ,   '%mod%/%jpn%', '.' ] ,
        'xml'       =>  [ 'XML'                    ,   '%mod%/%jpn%', '.' ] ,
        };
    
}

1;

