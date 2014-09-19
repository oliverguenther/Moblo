package Moblo;
use Mojo::Base 'Mojolicious';

sub startup {
    my $self = shift;

    # Router
    my $r = $self->routes;

    # GET / -> Main::index()
    $r->get('/')->to(template => 'main/index');
}

1;
