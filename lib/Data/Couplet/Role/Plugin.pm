use strict;
use warnings;

package Data::Couplet::Role::Plugin;

# ABSTRACT: A Generalised Role for classes to extend Data::Couplet via aggregation.

use Moose::Role;
use namespace::autoclean;

=head1 SYNOPSIS

Currently this role is nothing special, it does nothing apart from let me know that a class
doesn't just have a special name. This could change later, but its bare bones for a start.

=head1 WRITING PLUGINS

  package Data::Couplet::Plugin::MyPluginName;

  use Moose::Role;

  with Data::Couplet::Role::Plugin;

  sub foo {

  }
=cut

=head1 USING PLUGINS

There are many other ways of doing it, but this way is the most recommended.

  package My::Package::DataCouplet;

  use Moose;

  extends 'Data::Couplet';

  with 'Data::Couplet::Plugin::MyPluginName';

  __PACKAGE__->meta->make_immutable;

  1;

Then later

  use aliased 'My::Package::DataCouplet' => 'DC';

  my $DC->new();

  ... etc ...

=cut

no Moose::Role;
1;

