use strict;
use warnings;

package Data::Couplet::Plugin::Transform::GridList;

# ABSTRACT: Access all Data simultaneously in an index oriented way ( like a database )

use Moose::Role;
with 'Data::Couplet::Role::Plugin';
use MooseX::Types::Moose qw(:all);
use namespace::autoclean;

=head1 METHODS

=head2 gridlist_row ( Int ) : List[ $index, $keyscalar, $keyobject, $value ]

A simple row-wise accessor.

In common usage, $keyscalar and $keyobject will likely be the same, but in case you need it,
its here.

=cut

sub gridlist_row {
  my ( $self, $index ) = @_;
  Int()->assert_valid($index);
  if ( !$self->_ik_exists($index) ) {
    return;
  }
  my $key       = $self->_ik_get($index);
  my $keyobject = $self->_ko_get($key);
  my $value     = $self->_kv_get($key);
  return ( $index, $key, $keyobject, $value );
}

=head2 gridlist_rows ( List[ Int ] ) : List[ ArrayRef[ $index, $keyscalar, $keyobject, $value ]]

A simple rowset producer.

Like above, but retuns multiple items of your choosing.

=cut

sub gridlist_rows {
  my ( $self, @indices ) = @_;
  ( ArrayRef [Int] )->assert_valid( \@indices );
  my @out;
  for (@indices) {
    push @out, $self->gridlist_row($_);
  }
  return @out;
}

=head2 gridlist_update ( $index, $keyscalar, $keyobject , $value ) : List[ $index, $keyscalar, $keyobject, $value ]

Note: This uses only the index value to determine writeback.

Anything in its way will get royally stomped upon.

Also, for this to work, C<$index> must already be in the dataset.

To be friendly, we return any array containing what was replaced. ( This probably sounds insane, but it makes more sense for row-swaps )

  my @a = gridlist_row( 1 );
  hack(\@a);
  my @b = gridlist_update( \@a );
  hack(\@b);
  gridlist_update( \@b );

Note, this could be a really really dangerous thing to do, I Have thought of ways it can go wrong, but have yet to
make a good example case to show you why.
=cut

sub gridlist_update {
  my ( $self, $index, $keyscalar, $keyobject, $value ) = @_;

  # Poor mans validation.
  Int()->assert_valid($index);
  Value()->assert_valid($keyscalar);
  Item()->assert_valid($keyobject);
  Item()->assert_valid($value);
  my @orig = $self->gridlist_row($index);
  if ( not @orig ) {
    Carp::croak("Cannot update gridlist item $index, it does not exist ");
  }
  $self->_ik_set( $index, $keyscalar );
  $self->_ki_set( $keyscalar, $index );
  $self->_ko_set( $keyscalar, $keyobject );
  $self->_kv_set( $keyscalar, $value );
  return @orig;
}
no Moose::Role;
1;

