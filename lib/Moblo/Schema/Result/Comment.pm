package Moblo::Schema::Result::Comment;
use base qw/DBIx::Class::Core/;

use DateTime;

# Associated table in database
__PACKAGE__->table('comments');

# Load ColumnDefault for datetime
__PACKAGE__->load_components(qw/ColumnDefault Core/);
# Automatically load datetime columns into DateTime objects
__PACKAGE__->load_components(qw/InflateColumn::DateTime/);


# Column definition
__PACKAGE__->add_columns(

    id => {
        data_type => 'integer',
        is_auto_increment => 1,
    },

    post_id => {
        data_type => 'integer',
    },

    user_id => {
        data_type => 'integer',
    },

    created_at => {
        data_type => 'datetime',
        # call 'now()' SQL for current time
        is_nullable => 1,
        default_value => \"(datetime('now'))",
    },

    content => {
        data_type => 'text',
    }

);

# Tell DBIC that 'id' is the primary key
__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to(
    # Name of the accessor for this relation
    post =>
    # Foreign result class
    'Moblo::Schema::Result::Post',
    # Foreign key in THIS table
    'post_id'
);

__PACKAGE__->belongs_to(
    commenter =>
    'Moblo::Schema::Result::User',
    'user_id'
);

1;