use strict;
use warnings FATAL => 'all';

package Data::Couplet::Extension;

# ABSTRACT: A Convenient way for SubClassing Data::Couplet with minimal effort

use MooseX::Types::Moose qw( :all );
use Carp;

sub _dump {
  require Data::Dumper;
  local $Data::Dumper::Terse     = 1;
  local $Data::Dumper::Indent    = 0;
  local $Data::Dumper::Maxdepth  = 1;
  local $Data::Dumper::Quotekeys = 0;
  return Data::Dumper::Dumper(@_);
}

sub _carp_key {
  my $key     = shift;
  my $config  = shift;
  my $message = shift;
  carp( $key . ' => ' . _dump( $config->{$key} ) . ' ' . $message );
  return;
}

sub _croak_key {
  my $key     = shift;
  my $config  = shift;
  my $message = shift;
  croak( $key . ' => ' . _dump( $config->{$key} ) . ' ' . $message );
  return;
}

sub import {
  my $class  = shift;
  my %config = @_;
  my $caller = caller;

  require Moose;
  require Data::Couplet::Private;
  require Data::Couplet::Role::Plugin;

  $config{-into} = $caller unless exists $config{-into};

  #_croak_key( -into => \%config, 'target is not a valid ClassName' ) unless is_ClassName( $config{-into} );

  if ( $config{-into} eq 'main' ) {
    _carp_key( -into => \%config, '<-- is main, not injecting' );
    return;
  }

  $config{-base} = '' unless exists $config{-base};

  _croak_key( -base => \%config, 'is not a Str' ) unless is_Str( $config{-base} );

  $config{-basepackage} = 'Data::Couplet';
  if ( $config{-base} ne '' ) {
    $config{-basepackage} = 'Data::Couplet::' . $config{-base};
  }

  if ( $config{-basepackage} eq 'Data::Couplet' ) {
    require Data::Couplet;
  }

  _croak_key( -basepackage => \%config, 'is not a valid ClassName' )
    unless is_ClassName( $config{-basepackage} );

  $config{-with} = [] unless exists $config{-with};
  $config{-with_expanded} = [];

  _croak_key( -with => \%config, 'is not an ArrayRef' ) unless is_ArrayRef( $config{-with} );
  for ( @{ $config{-with} } ) {
    my $plugin = 'Data::Couplet::Plugin::' . $_;
    eval "require $plugin; 1" or croak("Could not load Data::Couplet plugin $plugin");
    croak("plugin $plugin loaded, but still seems not to be a valid ClassName") unless is_ClassName($plugin);
    croak("plugin $plugin cant meta")                                           unless $plugin->can('meta');
    croak("plugin $plugin meta cant does_role")                                 unless $plugin->meta->can('does_role');
    croak("plugin $plugin doesn't do DC::R:P") unless $plugin->meta->does_role('Data::Couplet::Role::Plugin');
    push @{ $config{-with_expanded} }, $plugin;
  }

  # Input validation and expansion et-all complete.
  # Inject warnings/strict for caller.
  strict->import();
  warnings->import();
  Moose->import( { into => $config{-into}, } );
  $config{-into}->can('extends')->( $config{-basepackage} );
  $config{-into}->can('with')->( @{ $config{-with_expanded} } );

}

sub unimport {

  # Sub Optimal, but cant be avoided atm because Moose lacks
  # A 3rd-Party friendly unimport
  goto \&Moose::unimport;
}

1;

