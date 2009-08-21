
use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  DISTNAME  => 'Data-Couplet',
  NAME      => 'Data::Couplet',
  AUTHOR    => 'Kent\ Fredric\ \<kentnl\ at\ cpan\.org\>',
  ABSTRACT  => 'Yet\ another\ \(But\ Hopefully\ Better\)\ Key\-Value\ Storage\ mechanism',
  VERSION   => '0.0100',
  EXE_FILES => [ qw() ],
  (eval { ExtUtils::MakeMaker->VERSION(6.31) } ? (LICENSE => 'perl') : ()),
  PREREQ_PM    => {
    "Test::More" => '0',
    "namespace::autoclean" => '0',
    "Test::Exception" => '0',
    "Test::use::ok" => '0',
    "Moose" => '0.84',
    "Carp" => '0',
  },
);
