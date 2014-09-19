#!/usr/bin/perl

use strict;
use warnings;

use FindBin;
BEGIN { unshift @INC, "$FindBin::Bin/../lib" }

use Moblo::Schema;

my $schema = Moblo::Schema->connect('dbi:SQLite:moblo.db');
$schema->deploy();
