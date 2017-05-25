package Api {
    sub route {
        my $routes = shift; 
        $routes->get('/')->to(action => 'index');
        $routes->get('/version')->to(action => 'index');
    }
}

1;