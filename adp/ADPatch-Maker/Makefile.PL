use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'ADPatch::Maker',
    AUTHOR              => 'Marcus Vinicius Ferreira <ferreira.mv@gmail.com>',
    VERSION_FROM        => 'lib/ADPatch/Maker.pm',
    ABSTRACT_FROM       => 'lib/ADPatch/Maker.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'ADPatch-Maker-*' },
);
