#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 22;

BEGIN {
    use_ok('MooseX::Storage');
}

{

    package Foo;
    use Moose;
    use MooseX::Storage;

    with Storage;

    has 'number'  => ( is => 'ro', isa => 'Maybe[Int]' );
    has 'string'  => ( is => 'ro', isa => 'Maybe[Str]' );
    has 'boolean' => ( is => 'ro', isa => 'Maybe[Bool]' );
    has 'float'   => ( is => 'ro', isa => 'Maybe[Num]' );
    has 'array'   => ( is => 'ro', isa => 'Maybe[ArrayRef]' );
    has 'hash'    => ( is => 'ro', isa => 'Maybe[HashRef]' );
    has 'object'  => ( is => 'ro', isa => 'Maybe[Foo]' );
}

{
    my $foo = Foo->new(
        number  => 10,
        string  => 'foo',
        boolean => 1,
        float   => 10.5,
        array   => [ 1 .. 10 ],
        hash    => { map { $_ => undef } ( 1 .. 10 ) },
        object  => Foo->new( number => 2 ),
    );
    isa_ok( $foo, 'Foo' );
    
    is_deeply(
        $foo->pack,
        {
            __CLASS__ => 'Foo',
            number    => 10,
            string    => 'foo',
            boolean   => 1,
            float     => 10.5,
            array     => [ 1 .. 10 ],
            hash      => { map { $_ => undef } ( 1 .. 10 ) },
            object    => { 
                            __CLASS__ => 'Foo',                
                            number    => 2 
                         },            
        },
        '... got the right frozen class'
    );
}

{
    my $foo = Foo->unpack(
        {
            __CLASS__ => 'Foo',
            number    => 10,
            string    => 'foo',
            boolean   => 1,
            float     => 10.5,
            array     => [ 1 .. 10 ],
            hash      => { map { $_ => undef } ( 1 .. 10 ) },
            object    => { 
                            __CLASS__ => 'Foo',                
                            number    => 2 
                         },            
        }        
    );
    isa_ok( $foo, 'Foo' );

    is( $foo->number, 10,    '... got the right number' );
    is( $foo->string, 'foo', '... got the right string' );
    ok( $foo->boolean,       '... got the right boolean' );
    is( $foo->float,  10.5,  '... got the right float' );
    is_deeply( $foo->array, [ 1 .. 10 ], '... got the right array' );
    is_deeply(
        $foo->hash,
        { map { $_ => undef } ( 1 .. 10 ) },
        '... got the right hash'
    );

    isa_ok( $foo->object, 'Foo' );
    is( $foo->object->number, 2,
        '... got the right number (in the embedded object)' );
}


{

    package Foo;
    use Moose;
    use Moose::Util::TypeConstraints;
    use MooseX::Storage;

    use Scalar::Util 'looks_like_number';

    with Storage;    
    
    subtype 'Natural' 
        => as 'Int'
        => where { $_ > 0 };
        
    subtype 'HalfNum' 
        => as 'Num'
        => where { "$_" =~ /\.5$/ };    
    
    subtype 'FooString'
        => as 'Str'
        => where { lc($_) eq 'foo' };
        
    subtype 'IntArray' 
        => as 'ArrayRef'
        => where { scalar grep { looks_like_number($_) } @{$_} };

    subtype 'UndefHash' 
        => as 'HashRef'
        => where { scalar grep { !defined($_) } values %{$_} };

    has 'number' => ( is => 'ro', isa => 'Maybe[Natural]' );
    has 'string' => ( is => 'ro', isa => 'Maybe[FooString]' );
    has 'float'  => ( is => 'ro', isa => 'Maybe[HalfNum]' );
    has 'array'  => ( is => 'ro', isa => 'Maybe[IntArray]' );
    has 'hash'   => ( is => 'ro', isa => 'Maybe[UndefHash]' );
    has 'object' => ( is => 'ro', isa => 'Maybe[Foo]' );
}

{
    my $foo = Foo->new(
        number => 10,
        string => 'foo',
        float  => 10.5,
        array  => [ 1 .. 10 ],
        hash   => { map { $_ => undef } ( 1 .. 10 ) },
        object => Foo->new( number => 2 ),
    );
    isa_ok( $foo, 'Foo' );
    
    is_deeply(
        $foo->pack,
        {
            __CLASS__ => 'Foo',
            number    => 10,
            string    => 'foo',
            float     => 10.5,
            array     => [ 1 .. 10 ],
            hash      => { map { $_ => undef } ( 1 .. 10 ) },
            object    => { 
                            __CLASS__ => 'Foo',                
                            number    => 2 
                         },            
        },
        '... got the right frozen class'
    );
}

{
    my $foo = Foo->unpack(
        {
            __CLASS__ => 'Foo',
            number    => 10,
            string    => 'foo',
            float     => 10.5,
            array     => [ 1 .. 10 ],
            hash      => { map { $_ => undef } ( 1 .. 10 ) },
            object    => { 
                            __CLASS__ => 'Foo',                
                            number    => 2 
                         },            
        }        
    );
    isa_ok( $foo, 'Foo' );

    is( $foo->number, 10,    '... got the right number' );
    is( $foo->string, 'foo', '... got the right string' );
    is( $foo->float,  10.5,  '... got the right float' );
    is_deeply( $foo->array, [ 1 .. 10 ], '... got the right array' );
    is_deeply(
        $foo->hash,
        { map { $_ => undef } ( 1 .. 10 ) },
        '... got the right hash'
    );

    isa_ok( $foo->object, 'Foo' );
    is( $foo->object->number, 2,
        '... got the right number (in the embedded object)' );
}
