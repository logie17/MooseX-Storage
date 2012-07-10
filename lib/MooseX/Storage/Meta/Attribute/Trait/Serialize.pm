package MooseX::Storage::Meta::Attribute::Trait::Serialize;
use Moose::Role;

our $VERSION   = '0.31';
our $AUTHORITY = 'cpan:STEVAN';

# register this alias ...
package Moose::Meta::Attribute::Custom::Trait::Serialize;

our $VERSION   = '0.31';
our $AUTHORITY = 'cpan:STEVAN';

sub register_implementation { 'MooseX::Storage::Meta::Attribute::Trait::Serialize' }

1;
