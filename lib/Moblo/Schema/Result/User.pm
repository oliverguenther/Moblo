package Moblo::Schema::Result::User;
use base qw/DBIx::Class::Core/;

# Associated table in database
__PACKAGE__->table('users');

# Column definition
__PACKAGE__->add_columns(

    id => {
        data_type => 'integer',
        is_auto_increment => 1,
    },

    pw_hash => {
        data_type => 'text',
    },

    username => {
        data_type => 'text',
    },

    fullname => {
        data_type => 'text',
    },

);

__PACKAGE__->add_unique_constraint(
    [ qw/username/ ],
);

# Tell DBIC that 'id' is the primary key
__PACKAGE__->set_primary_key('id');

__PACKAGE__->has_many(
    # Name of the accessor for this relation
    posts =>
    # Foreign result class
    'Moblo::Schema::Result::Post',
    # Foreign key in the table 'posts'
    'author_id'
);

__PACKAGE__->has_many(
    comments =>
    'Moblo::Schema::Result::Comment',
    'user_id'
);

1;