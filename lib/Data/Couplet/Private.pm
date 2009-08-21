package Data::Couplet::Private;

# ABSTRACT: Private internal bits for Data::Couplet

# $Id:$
use strict;
use warnings;
use Moose;
use Carp;
use namespace::autoclean;

=head1 SYNOPSIS

This class contains all the private stuff Data::Couplet uses.

This arrangement is somewhat experimental, but its benefits are as follows

=over 4

=item - Publically Readable Private Documentation

Ensures that other people hacking on internals have plenty to work with

=item - Private Documentation Seperate from Public

Ensures end users don't get weighed down and tempted by stuff they don't need.

=item - Seperation of Concerns

Seperates logically the interface from the implementation, allowing for more
disperse changes without worry about breaking things.

=back

The above structure could also be reverted back to something more sane, but you
shouldn't mind, you don't rely on private methods anyway, do you? :)

=cut

=head1 ATTRIBUTES

These might change yet from a hash quad to something simpler, like

    [  k, k, k, ]
    { k => [ i, k, v ], k => [ i, k, v ] }

=head2 _ko : rw HashRef

Stores a mapping of Keys to Objects.

    { KEY_SCALAR => $KEY_OBJECT }

This is our internal way of mapping scalar representations of objects back to the objects.
NB: Because of how the scalarfication works at present, if an object is used for a key that
has string overload, the overloaded value will be used in the index.

=cut

has _ko => ( isa => 'HashRef', is => 'rw', default => sub { +{} }, );

=head2 _kv : rw HashRef

Stores a mapping of Keys to Values

    { KEY_SCALAR => $VALUE_OBJECT }

This is our primary datastore, unorderd, this is the part of the data that directly represents
what you would get with a normal hash.

=cut

has _kv => ( isa => 'HashRef', is => 'rw', default => sub { +{} }, );

=head2 _ki : rw HashRef

Stored a mapping of Keys to Indicies.

    { KEY_SCALAR => $INDEX_SCALAR }

This is required if you need to know where in an array a key is without having
to search the array for it. It also makes dataset reordering
much easier, increment values :)

=cut

has _ki => ( isa => 'HashRef', is => 'rw', default => sub { +{} }, );

=head2 _ik : rw ArrayRef

This keeps our keys in order

    [ KEY_SCALAR , KEY_SCALAR ]

=cut

has _ik => ( isa => 'ArrayRef', is => 'rw', default => sub { [] }, );

=head1 METHODS

=head2 ->_object_to_key ( $object ) : String

 Maps Anything to a usable Key.
 Essentially, stringify.
 This is done this way in case we need to change it later

=cut

sub _object_to_key {
  my ( $self, $object ) = @_;
  {
    no warnings;
    return "$object";
  }
}

=head2 ->_unset_at ( Int $index ) : $self : Modifier

 Deletes things that are found using an index only.

=cut

sub _unset_at {
  my ( $self, $index ) = @_;
  splice @{ $self->{_ik} }, $index, 1;
  return $self;
}

=head2 ->_unset_key ( String $key ) : $self : Modifier

 Deletes things that are found using a key only

=cut

sub _unset_key {
  my ( $self, $key ) = @_;

  # Forget Where
  delete $self->{_ki}->{$key};

  # Forget What it is
  delete $self->{_ko}->{$key};

  # Forget what it means
  delete $self->{_kv}->{$key};

  return $self;
}

=head2 ->_move_key_range( Int $left , Int $right , Int $jump ) : $self : Modifier

 Move a set of keys in the hash
 by $amt in $sign direction
 ->_move_key_range( $start, $stop , -1 ); # move left
 ->_move_key_range( $start, $stop , +1 ); # move right

=cut

sub _move_key_range {
  my ( $self, $start, $stop, $amt ) = @_;
  for( $start .. $stop  ) {
    $self->{_ki}->{ $self->{_ik}->[$_] } += $amt;
  }
  return $self;
}

=head2 ->_index_key ( String $key ) : Int : Modifier

Given a key, asserts it is in the dataset, either by finding it
or by creating it. Returns where the key is.

=cut

sub _index_key {
  my ( $self, $key ) = @_;
  if ( exists $self->{_ki}->{$key} ) {
    return $self->{_ki}->{$key};
  }
  my $index = ( push @{ $self->{_ik} }, $key ) - 1;
  return $index;
}

=head2 ->_set ( Any $object , Any $value ) : $self : Modifier

Insertion is easy. Everything that inserts the easy way
can call this.

=cut

sub _set {
  my ( $self, $object, $value ) = @_;
  my $key = $self->_object_to_key($object);
  $self->_set_kiov( $key, $self->_index_key($key), $object, $value );
  return $self;
}

=head2 ->_set_kiov ( String $key , Int $index, Any $object , Any $value ) : $self : Modifier

Handles the part of assigning all the Key => Value association needed in many parts.

=cut

sub _set_kiov {
  my ( $self, $k, $i, $o, $v ) = @_;
  $self->{_ki}->{$k} = $i;
  $self->{_ko}->{$k} = $o;
  $self->{_kv}->{$k} = $v;
  return $self;
}

=head2 ->_sync_ki : $self : Modifier

Assume _ki is dead, and _ik is in charge, rebuild
_ki from _ik

=cut

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

=head2 ->_sync_ik : $self : Modifier

Assume _ik is dead, and _ki is in charge,
rebuild _ik from _ki

=cut

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

