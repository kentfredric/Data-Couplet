package Data::Couplet::Plugin::My::Plugin;
our $VERSION = '0.02004302';


# $Id:$
use Moose::Role;

with 'Data::Couplet::Role::Plugin';

use namespace::autoclean;

sub useless_routine {
  return 'I am Useless';
}
no Moose::Role;
1;

