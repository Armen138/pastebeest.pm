package Pastebeest {
    use Syntax::Keyword::Try;
    use Pastebeest::Routes::Web;
    use Pastebeest::Routes::Api;
    use Pastebeest::Routes::Resource;
    use Pastebeest::Query;
    use Pastebeest::Model::Paste;

    use Mojo::Base 'Mojolicious';
    use Mojo::Pg;
    use Mojo::Pg::Migrations;
    use Mojolicious::Plugin::AssetPack;
    use SQL::Abstract::More;

    has pg => sub { 
        my $self = shift;
        return Mojo::Pg->new("postgresql://"
            . $self->config->{mojo}->{postgres}->{username} . ":"
            . $self->config->{mojo}->{postgres}->{password} . "@"
            . $self->config->{mojo}->{postgres}->{host} . "/"
            . $self->config->{mojo}->{postgres}->{database});
    };

    # This method will run once at server start
    sub startup {
        my $self = shift;

        my $home = Mojo::Home->new;
        $home->detect;

        # Load plugin and pipes in the right order
        $self->plugin( 'AssetPack', { pipes => [qw(Sass Css TypeScript JavaScript)] } );
        # define assets
        $self->asset->store->paths([$home->child("resources"), $home->child("node_modules")]);
        $self->asset->process("bootstrap.css" => "http://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.6/css/bootstrap.min.css");
        $self->asset->process("bootstrap.js"  => "http://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.6/js/bootstrap.min.js");
        $self->asset->process("system.js"     => "https://cdnjs.cloudflare.com/ajax/libs/systemjs/0.20.12/system.src.js");
        $self->asset->process("fonts.css"     => "http://fonts.googleapis.com/css?family=Roboto");
        $self->asset->process("app.css"       =>  "/scss/app.scss");
        # $self->asset->process("tether.css"    =>  "tether/dist/css/tether.css");
        # $self->asset->process("tether.js"     =>  "tether/dist/js/tether.js");

        # Share configuration with NPM from "package.json"
        my $config =
        $self->plugin( 'JSONConfig', { file => $home->child('package.json') } );
        
        $self->pg->abstract(SQL::Abstract::More->new(array_datatypes => 1));

        Pastebeest::Model::connect($self->pg);
        Pastebeest::Query::connect($self->pg);

        # test
        # Pastebeest::Model::Paste->order_by("modified" => "asc")->limit(12)->get();
        
        # Don't tell a soul
        $self->secrets( $config->{mojo}->{secrets} );

        # Because I want to know things when the interwebs are unavailable.
        $self->plugin('PODRenderer') if $config->{perldoc};

        # Allow configuration to dictate project structure
        push @{ $self->renderer->paths }, $home->child($config->{mojo}->{templates});
        push @{ $self->static->paths },   $home->child($config->{mojo}->{static});

        # Create parent route for API
        my $api = $self->routes->any('/api')->to( controller => 'api' );

        # All view routes should be declared in the Routes::Web module
        Web::route( $self->routes );

        # All api routes should be declared in the Routes::Api module
        Api::route($api);

        # The Routes::Resource module is special, it will create RESTful routes for a given resource.
        # In this case, we are reading an array of required resources from the configuration file.
        if ( $config->{mojo}->{rest} ) {
            foreach my $resource ( @{ $config->{mojo}->{rest} } ) {
                my $resourceRoute =
                $api->any($resource)->to( controller => $resource );
                Resource::route($resourceRoute);
            }
        }
        push @{$self->commands->namespaces}, 'Pastebeest::Command';
    }
}

1;
