use strict;
use warnings;

use Test::More;
use Data::Couplet;

sub Couplet(){ 'Data::Couplet' }

my $t = 0;



my $object;

$t++;
eval {
    $object = new_ok(Couplet);
};

$t++;

done_testing( $t );




