package Mojolicious::Command::generate::user;
use Mojo::Base 'Mojolicious::Command';

has description => 'Generate a new user for Moblo.';
has usage => "APPLICATION generate user [USERNAME] [PASSWORD] [FULL NAME]\n";

sub run {
  my ($self, $user, $password, $name) = @_;

  die "Missing attributes" unless ($user && $password && $name);

  my $users = $self->app->db->resultset('User');

  my $created = $users->create({
    username => $user,
    pw_hash => $self->app->bcrypt($password),
    fullname => $name,
  });

  say "Created user '$user' with id " . $created->id;
}

1;