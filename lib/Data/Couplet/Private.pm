package Data::Couplet::Private;

# $Id:$
use strict;
use warnings;
use Moose::Role;
use Carp;
use namespace::autoclean;

=head1 PRIVATE ATTRIBUTES

NO User Servicable Parts Inside.

Also, this might change yet from a hash quad to something simpler, like

    [  k, k, k, ]
    { k => [ i, k, v ], k => [ i, k, v ] }

=head2 _ko : rw HashRef

Stores a mapping of Keys to Objects.

This is our internal way of mapping scalar representations of objects back to the objects.
NB: Because of how the scalarfication works at present, if an object is used for a key that
has string overload, the overloaded value will be used in the index.

=cut

# Maps Keys to Object/Index pairs.
#
# { KEY_SCALAR => $KEY_OBJECT  }
#
has _ko => (
  isa     => 'HashRef',
  is      => 'rw',
  default => sub { +{} },
);

=head2 _kv : rw HashRef

Stores a mapping of Keys to Values

This is our primary datastore, unorderd, this is the part of the data that directly represents
what you would get with a normal hash.

=cut

# The Primary Key<=> Value Corelation.
#
# { KEY_SCALAR => $VALUE_OBJECT }
#

has _kv => (
  isa     => 'HashRef',
  is      => 'rw',
  default => sub { +{} },
);

=head2 _ki : rw HashRef

Stored a mapping of Keys to Indicies.

This is required if you need to know where in an array a key is without having
to search the array for it. It also makes dataset reordering
much easier, increment values :)

=cut

# This Maps Keys to indicies
#
# { KEY_SCALAR => $INDEX_SCALAR }
#

has _ki => (
  isa     => 'HashRef',
  is      => 'rw',
  default => sub { +{} },
);

=head2 _ik : rw ArrayRef

This keeps our keys in order

=cut

# The secondary Index=>Key correlation map
# Note: this is updated last
# { INDEX_SCALAR => KEY_SCALAR }

has _ik => (
  isa     => 'ArrayRef',
  is      => 'rw',
  default => sub { [] },
);

# Maps Anything to a usable Key.
# Essentially, stringify.
# This is done this way in case we need to change it later
#
sub _object_to_key {
  my ( $self, $object ) = @_;
  {
    no warnings;
    return "$object";
  }
}

#
# Deletes things that are found using an index only.
#
#
sub _unset_at {
  my ( $self, $index ) = @_;
  splice @{ $self->{_ik} }, $index, 1;
  return $self;
}

#
# Deletes things that are found using a key only
#
#
sub _unset_key {
  my ( $self, $key ) = @_;

  # Forget Where
  delete $self->{_ki}->{$key};

  # Forget What it is
  delete $self->{_ko}->{$key};

  # Forget what it means
  delete $self->{_kv}->{$key};
}

# Move a set of keys in the hash
# by $amt in $sign direction
# ->_move_key_range( $start, $stop , -1 ); # move left
# ->_move_key_range( $start, $stop , +1 ); # move right

sub _move_key_range {
  my ( $self, $start, $stop, $amt ) = @_;
  for ( $start .. $stop ) {
    $self->{_ki}->{ $self->{_ik}->[$_] } += $amt;
  }
  return $self;
}

# Returns index numbers for keys AND ASSIGNS THEM
#
sub _index_key {
  my ( $self, $key ) = @_;
  if ( exists $self->{_ki}->{$key} ) {
    return $self->{_ki}->{$key};
  }
  my $index = ( push @{ $self->{_ik} }, $key ) - 1;
  return $index;
}

# Given a key, records the 3 thins you could want to know for a key
# Index, Object, Value
#
sub _set_kiov {
  my ( $self, $k, $i, $o, $v ) = @_;
  $self->{_ki}->{$k} = $i;
  $self->{_ko}->{$k} = $o;
  $self->{_kv}->{$k} = $v;
  return $self;
}

sub _sync_ki {
  my ($self) = @_;
  $self->{_ki} = {};
  my $i = 0;
  for ( @{ $self->{_ik} } ) {
    $self->{_ki}->{$_} = $i;
    $i++;
  }
  return $self;
}

sub _sync_ik {
  my ($self) = @_;
  my @p = %{ $self->{_ki} };
  $self->{_ik} = [];
  $self->{_ki} = {};
  my @pp;
  while (@p) {
    push @pp, [ shift @p, shift @p ];
  }
  @pp = sort { $a->[1] <=> $b->[1] } @pp;
  while (@pp) {
    my $kv    = shift @pp;
    my $key   = $kv->[0];
    my $index = ( push @{ $self->{_ik} }, $key ) - 1;
    $self->{_ki}->{$key} = $index;
  }
}

1;

