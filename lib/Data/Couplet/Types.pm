use strict;
use warnings;

package Data::Couplet::Types;

# ABSTRACT: Various type-constraints for working with D::C and Moose

use MooseX::Types::Moose qw( :all );
use MooseX::Types -declare => [
  qw(
    DataCouplet
    DataCoupletImpl
    DataCoupletPlugin
    )
];

=head1 EXPORTED TYPES

=head2 DataCouplet

All children of Data::Couplet.

=head3 COERCIONS

=head4 ArrayRef

Will behave as if somebody had done

  Data::Couplet->new( @{ $arrayref });

=head4 HashRef

As for ArrayRef, but don't try thinking it will retain order.

=cut

class_type DataCouplet, { class => 'Data::Couplet' };

coerce DataCouplet, from ArrayRef, via {
  require Data::Couplet;
  return Data::Couplet->new( @{$_} );
};

coerce DataCouplet, from HashRef, via {
  require Data::Couplet;
  return Data::Couplet->new( %{$_} );
};

=head2 DataCoupletImpl

Anything that implements something like Data::Couplet.

That is, any descendant of Data::Couplet::Private

All DataCouplet instances should also be DataCoupletImpl instances.

=cut

class_type DataCoupletImpl, { class => 'Data::Couplet::Private' };

=head2 DataCoupletPlugin

Plugins

=cut

role_type DataCoupletPlugin, { role => 'Data::Couplet::Role::Plugin' };

1;

