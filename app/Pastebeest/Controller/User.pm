package Pastebeest::Controller::User {
    use Pastebeest::Model::User;
    use Mojo::Base 'Mojolicious::Controller';

    # This is a resource controller
    sub index {
        my $self = shift;
        # Render json response
        my $pastes = [{
            "body" => "this is raw code",
            "lang" => "perl"
        },{
            "body" => "this is raw code",
            "lang" => "perl"        
        }];
        $self->render(json => $pastes);
    }

    # Just to see what will happen ... 
    sub show {
        my $self = shift;
        my $id = $self->stash('id');
        my $response = Pastebeest::Model::User->find($id);
        if($response) {
            $self->render(json => {%$response});    
        } else {
            $self->render(text => "no such user", status => 404);
        }
        
    }

    sub create {
        # dummy input, testing
        my $self = shift;
        my $user = Pastebeest::Model::User->new({ username => "testuser", email => 'test@user.com', password => "supersecret" });
        my $result = $user->save;
        $self->render(json => {%$result});
    }
}

1;
