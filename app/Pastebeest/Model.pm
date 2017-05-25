package Pastebeest::Model {
    use Syntax::Keyword::Try;
    use Mojo::Base 'Pastebeest::Query';
    use Mojo::Pg;
    use Mojo::Util 'monkey_patch';
    use Data::Dumper;

    state $pg = undef;
    
    sub index { "id" }
    
    sub connect {
        $pg = shift;
    }

    sub has_many {
        my ($model, $name, $id) = @_;
        monkey_patch __PACKAGE__, $name, sub {
            my $self = shift;
            $model->where($id => $self->id)->get();
        };                                                                
    }

    sub has_one {
        my ($model, $name, $id) = @_;
        monkey_patch __PACKAGE__, $name, sub {
            my $self = shift;
            $model->where($id => $self->id)->get();
        };                                                        
    }

    sub belongs_to {
        my ($self, $model, $name, $id) = @_;

        $name = ($model =~s/(.*::)([^:]+)\z/\L$2/r) unless defined $name;
        $id   = $name.'_id' unless defined $id;
        monkey_patch $self, $name, sub {
            my $self = shift;
            $model->find($self->{$id});
        };                                                
    }

    sub new {
        my $class = shift;
        my $attributes = $pg->db->query('select column_name from information_schema.columns where table_name=?', $class->table)
            ->hashes->map(sub { $_->{column_name} });
        $class->attr($attributes->to_array);
        bless @_ ? @_ > 1 ? {@_} : {%{$_[0]}} : {}, ref $class || $class;
    }

    sub all {
        my $class = shift;
        # my ($class, $limit) = @_;
        my $data = undef;
        try {
            $data = $pg->db->select($class->table, '*');
            if ($data->rows == 0) {
                # return 404;
                return undef;
            }
        } catch {
            return { "error" => $@ };
        }
        $data->hashes;
    }

    sub find {
        my ($class, $id) = @_;
        my $data = undef;
        try {
            $data = $pg->db->select($class->table, '*', {$class->index, $id});
            if ($data->rows == 0) {
                # return 404;
                return undef;
            }
            $data = $data->hashes->first;
        } catch {
            return { "error" => $@ };
        }
        bless $data, $class;
    }

    sub save {
        my $self = shift;
        try {
            if (not $self->id) {
                # insert
                $self->id($pg->db->insert($self->table, {%$self}, {returning => 'id'})->hashes->first->{id});
            } else {
                # update
                $pg->db->update($self->table, {%$self}, { id => 'id' });
            }
            return $self;
        } catch {
            return { "error" => $@ };
        }
    }
}

1;
