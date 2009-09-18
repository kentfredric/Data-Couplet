use strict;
use warnings;

package Data::Couplet::Util::Validate;

# ABSTRACT: Some Convenient Type validation functions for parameters that wouldn't be needed with MX::D

use Sub::Exporter -setup => { exports => [qw( assert_all_Int )], };
use namespace::autoclean;

1;

