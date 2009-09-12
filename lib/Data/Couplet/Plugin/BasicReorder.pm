use strict;
use warnings;

package Data::Couplet::Plugin::BasicReorder;

# ABSTRACT: A D::C Plug-in to reorder data in your data set.

# $Id:$
use Moose::Role;
use namespace::autoclean;

with 'Data::Couplet::Role::Plugin';

=head1 SYNOPSIS

This is currently a whopping big TODO.

Patches welcome.


=head1 METHODS

=cut

=head3 ->move_up( Any $object | String $key , Int $amount ) : $self : Modifier

=cut

sub move_up {
  my ( $self, $object, $stride ) = @_;
  return $self;
}

=head3 ->move_down( Any $object | String $key , Int $amount ) : $self : Modifier

=cut

sub move_down {
  my ( $self, $object, $stride ) = @_;
  return $self;
}

=head3 ->swap( Any|Str $key_left, Any|Str $key_right  ) : $self : Modifier

=cut

sub swap {
  my ( $self, $key_left, $key_right ) = @_;
  return $self;
}

no Moose::Role;

1;

