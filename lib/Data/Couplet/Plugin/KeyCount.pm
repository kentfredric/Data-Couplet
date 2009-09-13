use strict;
use warnings;

package Data::Couplet::Plugin::KeyCount;
our $VERSION = '0.02004302';


# ABSTRACT: Provides various methods for seeing how many things are in the object

use Moose::Role;

use namespace::autoclean;

with 'Data::Couplet::Role::Plugin';


sub count {
  my ($self) = @_;
  my @d = @{ $self->{_ik} };
  return scalar @d;
}


sub last_id {
  my ($self) = @_;
  my @d = @{ $self->{_ik} };
  return $#d;
}

no Moose::Role;

1;


__END__

=pod

=head1 NAME

Data::Couplet::Plugin::KeyCount - Provides various methods for seeing how many things are in the object

=head1 VERSION

version 0.02004302

=head3 ->count() : Int

Number of items contained



=head3 ->last_id() : Int

Returns the last Id



=head1 AUTHOR

  Kent Fredric <kentnl at cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by Kent Fredric.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut 


