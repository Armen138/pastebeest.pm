# "RestFul Routing" according to http://restfulrouting.com/#introduction
# INDEX	GET
# SHOW	GET
# CREATE	POST
# NEW	GET
# EDIT	GET
# UPDATE	PUT
# DESTROY	DELETE


package Resource {
    sub route {
        my $routes = shift; 
        $routes->get('/')->to(action => 'index');
        $routes->get('/new')->to(action => 'create');
        $routes->post('/')->to(action => 'create');
        $routes->get('/:id')->to(action => 'show');
        $routes->put('/:id')->to(action => 'update');
        $routes->get('/:id')->to(action => 'show');
        $routes->delete('/:id')->to(action => 'destroy');
    }
}

1;