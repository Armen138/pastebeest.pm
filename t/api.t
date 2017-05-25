use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('Pastebeest');
$t->get_ok('/api')->status_is(200)->content_type_like(qr/application\/json/);
$t->get_ok('/api/version')->status_is(200)->content_type_like(qr/application\/json/)->json_has('/version');


done_testing();
