package Data::Couplet;

# $Id:$
use strict;
use warnings;
use Moose;
use Carp;
use MooseX::AttributeHelpers;
use namespace::autoclean;

# Maps Keys to Object/Index pairs.
#
# { KEY_SCALAR => $KEY_OBJECT  }
#
has _ko => (
  isa       => 'HashRef',
  is        => 'rw',
  default   => sub { +{} },
  metaclass => "Collection::Hash",
  provides  => {
    'set'    => '_ko_set',
    'get'    => '_ko_get',
    'exists' => '_ko_exists',
    'delete' => '_ko_delete',
  }
);

# The Primary Key<=> Value Corelation.
#
# { KEY_SCALAR => $VALUE_OBJECT }
#

has _kv => (
  isa       => 'HashRef',
  is        => 'rw',
  default   => sub { +{} },
  metaclass => "Collection::Hash",
  provides  => {
    'set'    => '_kv_set',
    'get'    => '_kv_get',
    'exists' => '_kv_exists',
    'delete' => '_kv_delete',
  }
);

# This Maps Keys to indicies
#
# { KEY_SCALAR => $INDEX_SCALAR }
#

has _ki => (
  isa       => 'HashRef',
  is        => 'rw',
  default   => sub { +{} },
  metaclass => "Collection::Hash",
  provides  => {
    'set'    => '_ki_set',
    'get'    => '_ki_get',
    'exists' => '_ki_exists',
    'delete' => '_ki_delete',
  }
);

# The secondary Index=>Key correlation map
# Note: this is updated last
# { INDEX_SCALAR => KEY_SCALAR }

has _ik => (
  isa       => 'ArrayRef',
  is        => 'rw',
  default   => sub { [] },
  metaclass => "Collection::Array",
  provides  => {
    'set'  => '_ik_set',
    'push' => '_ik_push',
    'get'  => '_ik_get',

    #   'exists'   => '_ik_exists',
    'delete'   => '_ik_delete',
    'elements' => '_ik_elements',
  }
);

sub _object_to_key {
  my ( $self, $object ) = @_;
  {
    no warnings;
    return "$object";
  }
}

sub BUILDARGS {
    my $class = shift;

    if ( scalar @_ & 1 ){
        Carp::croak("Uneven list sent. ERROR: Must be an ordered array that simulates a hash [k,v,k,v]");
    }
    my $c = {
        _ik => [],
        _ko => {},
        _kv => {},
        _ki => {},
    };
    while ( @_ ){
        my $key_object = shift;
        my $key = $class->_object_to_key( $key_object );
        my $value = shift;
        my $index = push @{$c->{_ik}} , $key;
        $c->{_ki}->{$key} = $index;
        $c->{_ko}->{$key} = $key_object;
        $c->{_kv}->{$key} = $value;
    }
    return $c;
}

sub set {
  my ( $self, $object, $value ) = @_;
  my $k = $self->_object_to_key($object);
  if ( $self->_kv_exists($k) ) {
    $self->_kv_set( $k, $value );
    return;
  }
  my $i = $self->_ik_push($k);
  $self->_ki_set( $k, $i );
  $self->_ko_set( $k, $object );
  $self->_kv_set( $k, $value );
  return $self;
}

sub unset {
  my ( $self, $object ) = @_;
  my $k = $self->_object_to_key($object);
  unless ( $self->_kv_exists($k) ) {
    return $self;
  }
  my $i = $self->_ki_get($k);
  $self->_ki_delete($k);
  $self->_ik_delete($i);
  $self->_ko_delete($k);
  $self->_kv_delete($k);
  $self->_sync_ki;
  return $self;
}

sub _sync_ki {
  my ($self) = @_;
  $self->_ki( {} );
  my $i = 0;
  for ( $self->_ik_elements ) {
    $self->_ki_set( $_, $i );
    $i++;
  }
  return $self;
}

sub _store_key {
  my ( $self, $object ) = @_;
  my $key = $self->_object_to_key($object);
  $self->_ko_set( $key, $object );

  #  $self->_ki_set( $key, undef ) unless $self->_ki_exists( $key );
}

sub _erase_key {
  my ( $self, $object ) = @_;
  delete $self->{'_key_map'}->{ $self->_object_to_key($object) };
}

sub _key_address {
  my ( $self, $object ) = @_;
  my $key = $self->_object_to_key($object);
  if ( !exists $self->{'_key_map'}->{$key} ) {
    return undef;
  }
  return $self->{'_key_map'}->{$key}->[1];
}

sub value {
  my ( $self, $object ) = @_;
  my $key = $self->_object_to_key( $object );
  return $self->_kv_get( $key );
}

sub value_at {
  my ( $self, $index ) = @_;
  return 'value';

}

sub values {
  my ($self) = @_;
  return map { $self->_kv_get( $_ ) } $self->_ik_elements;
}

sub values_ref {
  my ($self) = @_;
  return [ $self->values(@_) ];
}

sub keys {
  my ($self) = @_;
  return map { $self->_ko_get( $_ ) } $self->_ik_elements;
}

sub key_at {
  my ( $self, $index ) = @_;
  return 'object';
}

sub key_object {
  my ( $self, $key ) = @_;
  return $self->_ko_get( $key );
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
1;

