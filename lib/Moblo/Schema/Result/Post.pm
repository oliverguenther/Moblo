package Moblo::Schema::Result::Post;
use base qw/DBIx::Class::Core/;

# Associated table in database
__PACKAGE__->table('posts');

# Column definition
__PACKAGE__->add_columns(

    id => {
        data_type => 'integer',
        is_auto_increment => 1,
    },

    author => {
        data_type => 'text',
    },

    title => {
        data_type => 'text',
    },

    content => {
        data_type => 'text',
    },

    date_published => {
        data_type => 'datetime',
    },

);

# Tell DBIC that 'id' is the primary key
__PACKAGE__->set_primary_key('id');

