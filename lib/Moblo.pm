package Moblo;
use Mojo::Base 'Mojolicious';
use Moblo::Schema;

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

    # Plugins

    # Bcrypt with cost factor 8
    $self->plugin('bcrypt', { cost => 8 });

    # Router
    my $r = $self->routes;

    # GET / -> Main::index()
    $r->get('/')->to(template => 'main/index');

    # Login routes
    $r->get('/login')->name('login_form')->to(template => 'login/login_form');
    $r->post('/login')->name('do_login')->to('Login#on_user_login');

    # View posts
    $r->get('/post/:id', [id => qr/\d+/])->name('show_post')->to('Post#show');

    my $authorized = $r->bridge('/admin')->to('Login#is_logged_in');
    $authorized->get('/')->name('restricted_area')->to(template => 'admin/overview');

    # Write new post
    $authorized->get('/create')->name('create_post')->to(template => 'admin/create_post');
    $authorized->post('/create')->name('publish_post')->to('Post#create');

    # Delete post
    $authorized->get('/delete/:id', [id => qr/\d+/])->name('delete_post')->to(template => 'admin/delete_post_confirm');
    $authorized->post('/delete/:id', [id => qr/\d+/])->name('delete_post_confirmed')->to('Post#delete');

    # Create comments
    $authorized->post('/post/:id/comments', [id => qr/\d+/])->name('create_comment')->to('Post#comment');

    my $schema = Moblo::Schema->connect('dbi:SQLite:share/moblo-schema.db', '', '', {sqlite_unicode => 1});
    $self->helper(db => sub { return $schema; });

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
