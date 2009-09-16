# http://www.perl.com/pub/a/2003/05/29/treasures.html


# perl medic
h2xs -AX --name=ADPatch::Maker

# file:///C:/pub/doc/perldoc-5.8.8/perlnewmod.html
h2xs -AX --skip-exporter --use-new-tests -n Foo::Bar

# http://www.perl.com/pub/a/2003/02/12/module1.html?page=2
# http://search.cpan.org/~kwilliams/Module-Build-0.2805/lib/Module/Build.pm

perl -e '

use Module::Build;

Module::Build->new
    ( module_name   => 'My::Module'
    , license       => 'perl'
    , requires      =>  { 'DBI' => 0
                        , 'DBD::Oracle' => '1.14'
                        }
    )->create_build_script;
'

# file:///C:/pub/doc/perldoc-5.8.8/perlnewmod.html
 module-starter \
    --module=ADPatch::Maker,ADPatch::Member,ADPatch::Member::Forms,ADPatch::DB,ADPatch::Utils,ADPatch::CGI,ADPatch::Build \
    --author="Marcus Vinicius Ferreira"     \
    --email="ferreira.mv@gmail.com"         \
    --force

