use strict;
use warnings;

use Test::More;
use Data::Couplet;

sub Couplet() { 'Data::Couplet' }
my $t = 0;

sub do_test(&) {
  my $c      = shift;
  my @caller = caller();
  $caller[2]--;
  ++$t;
  eval {
    $c->();
    1;
  } or ok( 0, "Test $t mystically failed ( @ $caller[2] )" );
}

my $object;

do_test {
  $object = new_ok(Couplet);
}
for 1 .. 2;

do_test {
  $object->set( "Hello", "World" );
  is( $object->value("Hello"), "World", "Data Storage Works" );
}
for 3 .. 4;

do_test {    #
  my $key = ["Magical Hash"];
  $object->set( $key, "World" );
  is( $object->value($key), "World", "Data Storage Works(Object Key)" );
}
for 5 .. 6;

do_test {
  my @values = $object->keys;
  is_deeply( \@values, [ "Hello", ["Magical Hash"], ["Magical Hash"] ], "Keys Retain Data" );
}
for 7 .. 8;

do_test {
  my @values = $object->values;
  is_deeply( \@values, [ "World", "World", "World" ], '->values returns the right stuff' );
}
for 9 .. 10;

do_test {
    $object = new_ok(Couplet, [ 'A' => 'B', 'C' => 'D' ] );
} for 11;

do_test {
   is_deeply([ $object->values ], ['B','D'] , 'Values Maintain Order' );
} for 12;

do_test {
   is_deeply([ $object->keys ], ['A','C'] , 'Keys Maintain Order' );
} for 13;




use Data::Dump qw( dump );

dump($object);
done_testing($t);

