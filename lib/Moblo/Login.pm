package Moblo::Login;
use Mojo::Base 'Mojolicious::Controller';

sub is_logged_in {
    my $self = shift;

    return 1 if $self->session('logged_in');

    $self->render(
        inline => "<h2>Forbidden</h2><p>You're not logged in. <%= link_to 'Go to login page.' => 'login_form' %>",
        status => 403
    );
}

# Mocked function to check the correctness
# of a username/password combination.
sub user_exists {
    my ($username, $password) = @_;

    return ($username eq 'foo' && $password eq 'bar');
}

sub on_user_login {
    my $self = shift;

    # Grab the request parameters
    my $username = $self->param('username');
    my $password = $self->param('password');

    if (user_exists($username, $password)) {

        $self->session(logged_in => 1);
        $self->session(username => $username);

        $self->redirect_to('restricted_area');
    } else {
        $self->render(text => 'Wrong username/password', status => 403);
    }
}

1;
