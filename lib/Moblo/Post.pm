package Moblo::Post;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::Util qw(xml_escape);
use DateTime;

sub create {
    my $self = shift;
    my $user = $self->_user_from_session;

    # Persist the post
    $self->db->resultset('Post')->create({
            title => $self->param('title'),
            content => $self->param('content'),

            author_id => $user->id,

            # Published now
            date_published => DateTime->now->iso8601,

        });


    $self->flash(post_saved => '1');
    $self->redirect_to('restricted_area');
}

sub delete {
    my $self = shift;

    my $posts = $self->db->resultset('Post');
    $posts->search({ id => $self->stash('id') })->delete;

    $self->flash(post_deleted => '1');
    $self->redirect_to('restricted_area');
}


sub show {
    my $self = shift;
    my $post = $self->_post_from_stash;
    my $user = $self->_user_from_session;

    if (defined $post) {
        $self->render(post => $post, logged_in => defined($user), user => $user);
    } else {
        $self->render_not_found;
    }
}

sub comment {
    my $self = shift;

    # Retrieve dbic objects
    my $post = $self->_post_from_stash;
    my $user = $self->_user_from_session;
    

    $post->create_related('comments', {
        user_id => $user->id,
        content => xml_escape($self->param('content')),
    });

    $self->render(template => 'post/show', post => $post, logged_in => defined($user), user => $user);
}

# This should be a helper.
sub _user_from_session {
    my $self = shift;

    return $self->db->resultset('User')->find($self->session('user_id'))
    if ($self->session('logged_in'));
}

sub _post_from_stash {
    my $self = shift;
    return $self->db->resultset('Post')->find($self->stash('id'));
}

1;
