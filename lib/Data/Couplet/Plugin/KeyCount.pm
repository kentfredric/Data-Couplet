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

=head3 ->last_id() : Int

Returns the last Id

=cut

sub last_id {
  my ($self) = @_;
  my @d = @{ $self->{_ik} };
  return $#d;
}

no Moose::Role;

1;

