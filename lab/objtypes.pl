#!perl
# $Id$


init_var();

while( <DATA> ) {

    chomp;
    print <<EOF
$_:
    - $ObjectType{$_}
    - $DestDir{$_}
    - $ExecCmd{$_}

EOF
}

sub init_var {
    # Adicionar
    #   .jar
    #   .doc
    #
    %ObjectType = (
        'tab'       => 'Table',
        'ttb'       => 'Temporary Table',
        'con'       => 'Constraint',
        'col'       => 'Alter Table Column',
        'seq'       => 'Sequence',
        'ind'       => 'Index',
        'grt'       => 'Grant',
        'syn'       => 'Synonym',
        'sql'       => 'SQL Script',
        'vw'        => 'Views',
        'ddl'       => 'Alter DB Objects',
        'PKS.pls'   => 'Package Specification',
        'PKB.pls'   => 'Package Body',
        'trg'       => 'Trigger',
        'odf.tab'   => 'Table    via ODF',
        'odf.seq'   => 'Sequence via ODF',
        'odf.vw'    => 'View     via ODF',
        'fmb'       => 'Forms',
        'rdf'       => 'Reports',
        'ogd'       => 'Graphics',
        'pll'       => 'PLL: Forms',
        'rep.pll'   => 'PLL: Reports',
        'ogd.pll'   => 'PLL: Graphics',
        'mnu'       => 'Menus',
        'msg'       => 'Messages OracleAppl',
        'wft'       => 'Workflow',
        'MSG.ldt'   => 'FND Message',
        'MNU.ldt'   => 'FND Menu',
        'DFF.ldt'   => 'FND Flexfield',
        'LKP.ldt'   => 'FND Lookup',
        'PRF.ldt'   => 'FND Profile',
        'VST.ldt'   => 'FND Value Set',
        'CCR.ldt'   => 'FND Concurrent',
        'RG.ldt'    => 'FND Request Group',
        'RQG.ldt'   => 'FND Request Group',
        'RQS.ldt'   => 'FND Request Set',
        'FP.ldt'    => 'Forms Personalization',
        'java'      => 'Java',
        'xml'       => 'XML',
        'txt'       => 'Text File',
        'drv'       => 'Applications Driver',
    );
    %ExecCmd = (
        'tab'       => 'sql      ${cli} ${dir} ${file} none none none sqlplus        &phase=tab+1  &un_${cli} &pw_${cli} %%              ',
        'ttb'       => 'sql      ${cli} ${dir} ${file} none none none sqlplus        &phase=tab+1  &un_${cli} &pw_${cli}                 ',
        'con'       => 'sql      ${cli} ${dir} ${file} none none none sqlplus        &phase=tab+10 &un_${cli} &pw_${cli} %%              ',
        'col'       => 'sql      ${cli} ${dir} ${file} none none none sqlplus_single &phase=tbm+1  &un_${cli} &pw_${cli}                 ',
        'seq'       => 'sql      ${cli} ${dir} ${file} none none none sqlplus        &phase=seq+1  &un_${cli} &pw_${cli} %%              ',
        'ddl'       => 'sql      ${cli} ${dir} ${file} none none none sqlplus        &phase=tbm+1  &un_apps   &pw_apps                   ',
        'ind'       => 'sql      ${cli} ${dir} ${file} none none none sqlplus        &phase=tbm+3  &un_${cli} &pw_${cli} &index_tspace %%',
        'grt'       => 'sql      ${cli} ${dir} ${file} none none none sqlplus        &phase=os+2   &un_${cli} &pw_${cli} &un_apps %%     ',
        'syn'       => 'sql      ${cli} ${dir} ${file} none none none sqlplus        &phase=os+3   &un_apps   &pw_apps   &un_${cli} %%   ',
        'sql'       => 'sql      ${cli} ${dir} ${file} none none none sqlplus        &phase=dat+10 &un_apps   &pw_apps                 ',
        'vw'        => 'sql      ${cli} ${dir} ${file} none none none sqlplus        &phase=vw     &un_apps   &pw_apps %%              ',
        'PKS.pls'   => 'sql      ${cli} ${dir} ${file} none none none package        &phase=pls    &un_apps   &pw_apps %%              ',
        'PKB.pls'   => 'sql      ${cli} ${dir} ${file} none none none package        &phase=plb    &un_apps   &pw_apps %%              ',
        'trg'       => 'sql      ${cli} ${dir} ${file} none none none package        &phase=pls    &un_apps   &pw_apps                 ',
        'odf.tab'   => 'exec     ${cli} ${dir} ${file} odf &phase=tab mode=tables   ',
        'odf.seq'   => 'exec     ${cli} ${dir} ${file} odf &phase=seq mode=sequences',
        'odf.vw'    => 'exec     ${cli} ${dir} ${file} odf &phase=vw  mode=views    ',
        'fmb'       => 'genform  ${cli} ${dir} ${file} %%',
        'rdf'       => 'genrep   ${cli} ${dir} ${file} %%',
        'ogd'       => 'genogd   ${cli} ${dir} ${file} %%',
        'pll'       => 'genfpll  ${cli} ${dir} ${file} %%',
        'rep.pll'   => 'genrpll  ${cli} ${dir} ${file} %%',
        'ogd.pll'   => 'gengpll  ${cli} ${dir} ${file} %%',
        'mnu'       => 'genmenu  ${cli} ${dir} ${file} %%',
        'msg'       => 'genmesg  ${cli} ${dir} ${file} %%',
        'wft'       => 'exec fnd bin WFLOAD  bin &phase=dat+10 &ui_apps 0 Y UPLOAD                                      \@${cli}:${dir}/${file}   ',
        'MSG.ldt'   => 'exec fnd bin FNDLOAD bin &phase=dat+10 &ui_apps 0 Y UPLOAD \@FND:patch/${appv}/import/afmdmsg.lct  \@${cli}:${dir}/${file}   ',
        'MNU.ldt'   => 'exec fnd bin FNDLOAD bin &phase=dat+10 &ui_apps 0 Y UPLOAD \@FND:patch/${appv}/import/afsload.lct  \@${cli}:${dir}/${file}   ',
        'DFF.ldt'   => 'exec fnd bin FNDLOAD bin &phase=dat+11 &ui_apps 0 Y UPLOAD \@FND:patch/${appv}/import/afffload.lct \@${cli}:${dir}/${file}   ',
        'LKP.ldt'   => 'exec fnd bin FNDLOAD bin &phase=dat+11 &ui_apps 0 Y UPLOAD \@FND:patch/${appv}/import/aflvmlu.lct  \@${cli}:${dir}/${file}   ',
        'QCD.ldt'   => 'exec fnd bin FNDLOAD bin &phase=dat+11 &ui_apps 0 Y UPLOAD \@FND:patch/${appv}/import/aflvmlu.lct  \@${cli}:${dir}/${file}   ',
        'PRF.ldt'   => 'exec fnd bin FNDLOAD bin &phase=dat+11 &ui_apps 0 Y UPLOAD \@FND:patch/${appv}/import/afscprof.lct \@${cli}:${dir}/${file}   ',
        'VST.ldt'   => 'exec fnd bin FNDLOAD bin &phase=dat+11 &ui_apps 0 Y UPLOAD \@FND:patch/${appv}/import/afffload.lct \@${cli}:${dir}/${file}   ',
        'CCR.ldt'   => 'exec fnd bin FNDLOAD bin &phase=dat+12 &ui_apps 0 Y UPLOAD \@FND:patch/${appv}/import/afcpprog.lct \@${cli}:${dir}/${file}   ',
        'RG.ldt'    => 'exec fnd bin FNDLOAD bin &phase=dat+14 &ui_apps 0 Y UPLOAD \@FND:patch/${appv}/import/afcpreqg.lct \@${cli}:${dir}/${file} %%',
        'RQG.ldt'   => 'exec fnd bin FNDLOAD bin &phase=dat+14 &ui_apps 0 Y UPLOAD \@FND:patch/${appv}/import/afcpreqg.lct \@${cli}:${dir}/${file} %%',
        'RQS.ldt'   => 'exec fnd bin FNDLOAD bin &phase=dat+14 &ui_apps 0 Y UPLOAD \@FND:patch/${appv}/import/afcprset.lct \@${cli}:${dir}/${file} %%',
        'FP.ldt'    => 'exec fnd bin FNDLOAD bin &phase=dat+11 &ui_apps 0 Y UPLOAD \@FND:patch/${appv}/import/affrmcus.lct \@${cli}:${dir}/${file}   ',
        'java'      => '',
        'xml'       => 'XML',
        'txt'       => '',
        'drv'       => '',
    );
    %DestDir = (
        'tab'       => 'patch/${appv}/sql',
        'ttb'       => 'patch/${appv}/sql',
        'con'       => 'patch/${appv}/sql',
        'col'       => 'patch/${appv}/sql',
        'seq'       => 'patch/${appv}/sql',
        'ind'       => 'patch/${appv}/sql',
        'grt'       => 'patch/${appv}/sql',
        'syn'       => 'patch/${appv}/sql',
        'sql'       => 'patch/${appv}/sql',
        'vw'        => 'patch/${appv}/sql',
        'ddl'       => 'patch/${appv}/sql',
        'odf.tab'   => 'patch/${appv}/sql',
        'odf.seq'   => 'patch/${appv}/sql',
        'odf.vw'    => 'patch/${appv}/sql',
        'ogd'       => 'admin/sql',
        'ogd.pll'   => 'admin/sql',
        'PKS.pls'   => 'admin/sql',
        'PKB.pls'   => 'admin/sql',
        'trg'       => 'admin/sql',
        'fmb'       => 'forms/US',
        'rdf'       => 'reports/US',
        'pll'       => 'resource',
        'rep.pll'   => 'resource',
        'mnu'       => 'admin/import',
        'msg'       => 'admin/import',
        'wft'       => 'admin/import',
        'MSG.ldt'   => 'admin/import',
        'MNU.ldt'   => 'admin/import',
        'DFF.ldt'   => 'admin/import',
        'LKP.ldt'   => 'admin/import',
        'PRF.ldt'   => 'admin/import',
        'VST.ldt'   => 'admin/import',
        'CCR.ldt'   => 'admin/import',
        'RG.ldt'    => 'admin/import',
        'RQG.ldt'   => 'admin/import',
        'RQS.ldt'   => 'admin/import',
        'FP.ldt'    => 'admin/import',
        'drv'       => 'admin/driver',
        'java'      => '${cli}/%jpn%',
        'xml'       => '${cli}/%jpn%',
        'txt'       => '.'        ,
    );
    %CopyCmd = (
        'default'   => 'copy     ${cli} ${dir} ${file} ${ver}',
        'java'      => 'copy     %jpn% ${file} ${ver}',
        'txt'       => 'NOCOPY',
    );

};

__DATA__
tab
ttb
con
seq
ind
grt
syn
sql
vw
col
ddl
PKS.pls
PKB.pls
trg
odf.tab
odf.seq
odf.vw
fmb
rdf
ogd
pll
rep.pll
ogd.pll
mnu
msg
wft
MSG.ldt
MNU.ldt
DFF.ldt
LKP.ldt
PRF.ldt
VST.ldt
CCR.ldt
RG.ldt
RQG.ldt
RQS.ldt
FP.ldt
java
xml
txt
drv