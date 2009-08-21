
use strict;
use warnings;

use Test::More;
use Test::Moose;

my $t = 0;

++$t;
use ok 'Data::Couplet';

++$t;
meta_ok('Data::Couplet');

++$t;
can_ok( 'Data::Couplet', qw( value value_at values keys key_at key_object set unset move_up move_down ) );

done_testing($t);
