package MooseX::Storage::Meta::Attribute::Serialize;
use Moose;

our $VERSION   = '0.31';
our $AUTHORITY = 'cpan:STEVAN';

extends 'Moose::Meta::Attribute';
   with 'MooseX::Storage::Meta::Attribute::Trait::Serialize';

# register this alias ...
package Moose::Meta::Attribute::Custom::Serialize;

our $VERSION   = '0.31';
our $AUTHORITY = 'cpan:STEVAN';

sub register_implementation { 'MooseX::Storage::Meta::Attribute::Serialize' }

1;
