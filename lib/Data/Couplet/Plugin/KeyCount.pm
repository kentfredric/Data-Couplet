use strict;
use warnings;

package Data::Couplet::Plugin::KeyCount;

# ABSTRACT: Provides a ->count method which indicates the number of keys

use Moose::Role;

use namespace::autoclean;

with 'Data::Couplet::Role::Plugin';

=head3 ->count() : Int

Number of items contained

=cut

sub count {
  my ($self) = @_;

  return scalar $self->keys;
}

no Moose::Role;

1;

