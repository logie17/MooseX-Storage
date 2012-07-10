#!/usr/bin/perl
$|++;
use strict;
use warnings;

use Test::More tests => 5;
use Test::Exception;
use Storable;

BEGIN {
    use_ok('MooseX::Storage');
}

{

    package Foo;
    use Moose;
    use MooseX::Storage;

    with Storage( traits => [qw|IgnoreUndefs|] );

    has 'number' => ( is => 'ro', isa => 'Int' );
    has 'string' => ( is => 'ro', isa => 'Str' );
    has 'float'  => ( is => 'ro', isa => 'Num' );
    has 'array'  => ( is => 'ro', isa => 'ArrayRef' );
    has 'hash'   => ( is => 'ro', isa => 'HashRef' );
    has 'object' => ( is => 'ro', isa => 'Object' );
}

{
    my $foo = Foo->new(
        number => 10,
    #   string => 'foo',
        float  => 10.5,
        array  => [ 1 .. 10 ],
        hash   => { map { $_ => undef } ( 1 .. 10 ) },
        object => Foo->new( number => 2 ),
    );
    isa_ok( $foo, 'Foo' );

    is_deeply(
        $foo->pack,
        {
          '__CLASS__' => 'Foo',
          'hash' => {
                      '6' => undef,
                      '3' => undef,
                      '7' => undef,
                      '9' => undef,
                      '2' => undef,
                      '8' => undef,
                      '1' => undef,
                      '4' => undef,
                      '10' => undef,
                      '5' => undef
                    },
          'array' => [
                       1,
                       2,
                       3,
                       4,
                       5,
                       6,
                       7,
                       8,
                       9,
                       10
                     ],
          'float' => '10.5',
          'object' => {
                        '__CLASS__' => 'Foo',
                        'hash' => undef,
                        'array' => undef,
                        'float' => undef,
                        'object' => undef,
                        'number' => 2,
                        'string' => undef
                      },
          'number' => 10,
          'string' => undef
        },
        '... got the data struct we expected'
    );

    my $foo2;
    lives_ok { $foo2 = Foo->unpack($foo->pack) } 'unpacks into a valid Moose obj';

    is_deeply(
        $foo2->pack,
        $foo->pack,
        '... if all goes well both object packs match'
    );
}

