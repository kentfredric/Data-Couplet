
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
    "Test::More" => '0',
    "namespace::autoclean" => '0',
    "Data::Dump" => '0',
    "Test::use::ok" => '0',
    "Moose" => '0.84',
    "Carp" => '0',
  },
  script_files => [ qw() ],
);

$build->create_build_script;
