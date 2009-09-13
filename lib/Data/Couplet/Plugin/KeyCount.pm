use strict;
use warnings;

package Data::Couplet::Plugin::KeyCount;

# ABSTRACT: Provides various methods for seeing how many things are in the object

use Moose::Role;

use namespace::autoclean;

with 'Data::Couplet::Role::Plugin';

=head3 ->count() : Int

Number of items contained

=cut

sub count {
  my ($self) = @_;
  my @d = @{ $self->{_ik} };
  return scalar @d;
}

=head3 ->last_index() : Int

Returns the last index value

=cut

sub last_index {
  my ($self) = @_;
  my @d = @{ $self->{_ik} };
  return $#d;
}

=head3 ->indices() : Array[Int]

Returns 0 .. ->last_index

=cut

sub indices {
  my ($self) = @_;
  return ( 0 .. $self->last_index );
}

no Moose::Role;

1;

