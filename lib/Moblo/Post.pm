package Moblo::Post;
use Mojo::Base 'Mojolicious::Controller';
use DateTime;

sub create {
    my $self = shift;

    # Persist the post
    $self->db->resultset('Post')->create({
            title => $self->param('title'),
            content => $self->param('content'),

            # Use the username as author name for now
            author => $self->session('username'),

            # Published now
            date_published => DateTime->now->iso8601,

        });


    $self->flash(post_saved => '1');
    $self->redirect_to('restricted_area');
}

sub delete {
    my $self = shift;

    my $posts = $self->db->resultset('Post');
    $self->app->log->info($self->stash('id'));
    $posts->search({ id => $self->stash('id') })->delete;

    $self->flash(post_deleted => '1');
    $self->redirect_to('restricted_area');
}

1;
