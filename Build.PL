
use strict;
use warnings;

use Module::Build;

my $build = Module::Build->new(
  module_name   => 'Data::Couplet',
  license       => 'perl',
  dist_abstract => "Yet\ another\ \(But\ Hopefully\ Better\)\ Key\-Value\ Storage\ mechanism",
  dist_name     => "Data\-Couplet",
  dist_author   => [
"Kent\ Fredric\ \<kentnl\ at\ cpan\.org\>",
  ],
  requires      => {
    "MooseX::Has::Sugar" => '0.0404',
    "MooseX::Types::Moose" => '0.19',
    "namespace::autoclean" => '0',
    "MooseX::Clone" => '0.04',
    "Carp" => '0',
    "Test::More" => '0',
    "MooseX::Types" => '0.19',
    "Data::Dump" => '0',
    "Test::use::ok" => '0',
    "Moose" => '0.84',
  },
  script_files => [ qw() ],
);

$build->create_build_script;
