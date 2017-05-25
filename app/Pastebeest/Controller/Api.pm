package Pastebeest::Controller::Api {
    use Mojo::Base 'Mojolicious::Controller';

    # Api routes should all return json responses
    # RESTful API routes should be generated through Routes::Resource instead
    sub index {
        my $self = shift;
        # Render json response
        my $version = {
            "version" => $self->app->config->{version},
            "name" => $self->app->config->{name}
        };
        $self->render(json => $version);
    }

    # Just to see what will happen ... 
    sub test {
        my $self = shift;
        my $response = {
            "test" => "test"
        };

        $self->render(json => $response);
    }
}
1;
