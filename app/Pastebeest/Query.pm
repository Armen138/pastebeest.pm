package Pastebeest::Query {
    use Syntax::Keyword::Try;
    use Mojo::Base -base;
    use Mojo::Util 'monkey_patch';
    use Mojo::Pg;
    use Data::Dumper;
    
    state $pg = undef;
    
    sub connect {
        $pg = shift;
    }
    my $query = {};

    my %NAMES = map { lc() => $_ } (
      qw( where limit order_by columns group_by having ) );

    for my $clause (keys %NAMES) {
      my $name = $clause;
      monkey_patch __PACKAGE__, $name, sub {
        my ($self, $args) = @_;
        $query->{"-" . $name} = $args;
        $self;
      };
    }

    # use data to build select query
    sub get {
        my $self = shift;
        # build select with sqla->select(%query);
        $query->{"-from"} = $self->table;
        say Dumper($query);
        my $data = $pg->db->select(%{$query});
        # say Dumper($data->hashes);
        return $data->hashes;
    }

    sub get_one {
        my $self = shift;
        # build select with sqla->select(%query);
        $query->{"-from"} = $self->table;
        say Dumper($query);
        my $data = $pg->db->select(%{$query});
        # say Dumper($data->hashes);
        return $data->hashes->first;
    }

}

1;