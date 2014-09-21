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

sub user_exists {
    my ($self, $username, $password) = @_;

    # Determine if a user with 'username' exists
    my $user = $self->db->resultset('User')
        ->search({ username => $username })->first;

    # Validate password against hash, return user object
    return $user if (
        defined $user &&
        $self->bcrypt_validate( $password, $user->pw_hash )
    );
}

sub on_user_login {
    my $self = shift;

    # Grab the request parameters
    my $username = $self->param('username');
    my $password = $self->param('password');

    if (my $user = $self->user_exists($username, $password)) {

        $self->session(logged_in => 1);
        $self->session(username => $username);
        $self->session(user_id => $user->id);

        $self->redirect_to('restricted_area');
    } else {
        $self->render(text => 'Wrong username/password', status => 403);
    }
}

1;
