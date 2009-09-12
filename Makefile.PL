
use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  DISTNAME  => 'Data-Couplet',
  NAME      => 'Data::Couplet',
  AUTHOR    => 'Kent\ Fredric\ \<kentnl\ at\ cpan\.org\>',
  ABSTRACT  => 'Yet\ another\ \(But\ Hopefully\ Better\)\ Key\-Value\ Storage\ mechanism',
  VERSION   => '0.02004206',
  EXE_FILES => [ qw() ],
  (eval { ExtUtils::MakeMaker->VERSION(6.31) } ? (LICENSE => 'perl') : ()),
  PREREQ_PM    => {
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
);
