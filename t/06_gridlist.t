use strict;
use warnings;

use Test::More;
use Test::Moose;

{

  package GridListTest;

  use Data::Couplet::Extension -with => [
    qw(
      Transform::GridList
      )
  ];

  __PACKAGE__->meta->make_immutable;
  1;
}

my $t = 0;

++$t;
my $o = new_ok('GridListTest');

++$t;
does_ok( $o, 'Data::Couplet::Plugin::Transform::GridList' );

++$t;
can_ok( $o, qw( gridlist_rows gridlist_update gridlist_row ) );

done_testing($t);

my @data = map { chr( $_ * 2 ), chr( $_ * 2 + 1 ) } ord('A') / 2 .. ord('z') / 2;

use Data::Dump qw( dump);

$o->set(@data);

dump $o->key_values_paired;

