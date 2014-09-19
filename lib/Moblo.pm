package Moblo;
use Mojo::Base 'Mojolicious';

sub startup {
    my $self = shift;

    # Allows to set the signing key as an array,
    # where the first key will be used for all new sessions
    # and the other keys are still used for validation, but not for new sessions.
    $self->secrets(['This secret is used for new sessionsLeYTmFPhw3q',
            'This secret is used _only_ for validation QrPTZhWJmqCjyGZmguK']);

    # The cookie name
    $self->app->sessions->cookie_name('moblo');

    # Expiration reduced to 10 Minutes
    $self->app->sessions->default_expiration('600');

    # Router
    my $r = $self->routes;

    # GET / -> Main::index()
    $r->get('/')->to(template => 'main/index');

    # Login routes
    $r->get('/login')->name('login_form')->to(template => 'login/login_form');
    $r->post('/login')->name('do_login')->to('Login#on_user_login');

    my $authorized = $r->bridge('/admin')->to('Login#is_logged_in');
    $authorized->get('/')->name('restricted_area')->to(template => 'admin/overview');

    # Logout route
    $r->route('/logout')->name('do_logout')->to(cb => sub {
            my $self = shift;

            # Expire the session (deleted upon next request)
            $self->session(expires => 1);

            # Go back to home
            $self->redirect_to('home');
        });


}

1;
