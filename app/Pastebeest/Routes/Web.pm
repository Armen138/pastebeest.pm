package Web {
    sub route {
        my $routes = shift;
        $routes->get('/')->to( controller => 'app', action => 'index' );
    }
}

1;