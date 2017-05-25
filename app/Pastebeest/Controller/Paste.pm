package Pastebeest::Controller::Paste {
    use Pastebeest::Model::Paste;
    use Mojo::Base 'Mojolicious::Controller';

    # This is a resource controller
    sub index {
        my $self = shift;
        my $pastes = Pastebeest::Model::Paste->all();
        $self->render(json => $pastes);
    }

    # Just to see what will happen ... 
    sub show {
        my $self = shift;
        my $id = $self->stash('id');
        my $response = Pastebeest::Model::Paste->find($id);
        if($response) {
            $self->render(json => {%$response});    
        } else {
            $self->render(text => "no such paste", status => 404);
        }
        
    }

    sub create {
        # dummy input, testing
        my $self = shift;
        my $paste = Pastebeest::Model::Paste->new({ slug => "testpaste3", body => "Test Paste Two", title => "Something something", "user_id" => 1});
        my $result = $paste->save;
        my $user = $paste->user;
        # $self->render(json => {%$result});
        $self->render(json => {%$user});
    }
}

1;
