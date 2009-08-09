package Data::Couplet;

# $Id:$
use strict;
use warnings;
use Moose;
use Data::Couplet::Private ();
use Carp;
use namespace::autoclean;

extends 'Data::Couplet::Private';

# Initialises the Object.
#
#
sub BUILDARGS {
  my $class = shift;

  if ( scalar @_ & 1 ) {
    Carp::croak("Uneven list sent. ERROR: Must be an ordered array that simulates a hash [k,v,k,v]");
  }

  my $c = Data::Couplet::Private->new();
  while (@_) {
    $c->_set( shift, shift );
  }
  return { %{$c} };
}

sub set {
  my ( $self, $object, $value ) = @_;
  $self->_set( $object, $value );
  return $self;
}

sub unset_at {
  my ( $self, $index ) = @_;
  my $key = $self->{_ik}->{$index};
  return $self->unset_key($key);
}

sub unset_key {
  my ( $self, $key ) = @_;
  unless ( exists $self->{_kv}->{$key} ) {
    return $self;
  }
  my $index = $self->{_ki}->{$key};
  $self->_unset_at($index);
  $self->_unset_key($key);
  $self->_move_key_range( $index, $#{ $self->{_ik} }, -1 );
  return $self;
}

sub unset {
  my ( $self, $object ) = @_;
  my $key = $self->_object_to_key($object);
  return $self->unset_key($key);
}

sub value {
  my ( $self, $object ) = @_;
  my $key = $self->_object_to_key($object);
  return $self->{_kv}->{$key};
}

sub value_at {
  my ( $self, $index ) = @_;
  my $key = $self->{_ik}->[$index];
  return $self->{_kv}->{$key};
}

sub values {
  my ($self) = @_;
  return map { $self->{_kv}->{$_} } @{ $self->{_ik} };
}

sub values_ref {
  my ($self) = @_;
  return [ $self->values(@_) ];
}

sub keys {
  my ($self) = @_;
  return map { $self->{_ko}->{$_} } @{ $self->{_ik} };
}

sub key_at {
  my ( $self, $index ) = @_;
  my $key = $self->{_ik}->[$index];
  return $self->{_ko}->{$key};
}

sub key_object {
  my ( $self, $key ) = @_;
  return $self->{_ko}->{$key};
}

sub move_up {
  my ( $self, $object, $stride ) = @_;
  return $self;
}

sub move_down {
  my ( $self, $object, $stride ) = @_;
  return $self;
}

sub swap {
  my ( $self, $key_left, $key_right ) = @_;
  return $self;
}

__PACKAGE__->meta->make_immutable();
1;

