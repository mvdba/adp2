#
# $Id$
#

package ADPatch::Maker;
use Class::Std;

# Def
{
    # Attributes
    %name_of        :ATTR( init_arg => 'name'       );
    %prd_of         :ATTR( init_arg => 'prd'        );
    %gap_of         :ATTR( init_arg => 'gap'        );
    %gap_ver_of     :ATTR( init_arg => 'gap_ver'    );
    %file_name_of   :ATTR( init_arg => 'file_name'  );
    %driver_of      :ATTR( init_arg => 'driver'     );

    # Constructor takes patch name like 'ar236g-1'
    sub new {
        my $class = shift;
        my $name  = shift;

        # new obj is a scalar
        my $new_obj = bless \do{my $anon_scalar}, $class;

        # initialize patch name components
        my %parts = _init( $name );
        $name_of   {ident $new_object} = $parts{name};
        $prd_of    {ident $new_object} = $parts{prd};
        $gap_of    {ident $new_object} = $parts{gap};
        $gap_ver_of{ident $new_object} = $parts{gap_ver};

        # Or
        # initialize patch name components
        my %init = parse( $name );
        $patch_of  {ident $new_object}{name}    = $init{name};
        $patch_of  {ident $new_object}{prd}     = $init{prd};
        $patch_of  {ident $new_object}{gap}     = $init{gap};
        $patch_of  {ident $new_object}{gap_ver} = $init{gap_ver};


        return $new_object;
    }

    sub _init {
        my $name = shift;
        my %p;
        my ($prd,$gap,$ver) = $name ~= m{};

        return %p;
    }

    sub add_file {
        my $member = shift;
        push @{ $self->{_members} }, $member;
    }

    sub DEMOLISH {
        my ($self, $ident) = @_;

    #   $filehandle_of{$ident}->flush();
    #   $filehandle_of{$ident}->close();

        return;
    }

    sub count_members : NUMERIFY {
        my $self = shift;
        my $ident = shift;
        return 99;
    }

    sub as_str : STRINGFY {
        my $self = shift;
        my $ident = shift;
        return printf '(%s)' $name_of{$ident};
    }

    sub is_okay : BOOLIFY {
        my $self = shift;
        return ! $self->is_valid();
    }
}

1;
