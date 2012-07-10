package MooseX::Storage::Engine::Trait::IgnoreUndefs;
use Moose::Role;

around 'collapse_attribute' => sub {
    my ($orig, $self, $attr, @args) = @_;

    my $value = $self->collapse_attribute_value($attr, @args);
    $self->storage->{$attr->name} = $value;

    return;
};

around 'expand_attribute' => sub {
    my ($orig, $self, $attr, $data, $options) = @_;
    my $value = $self->expand_attribute_value($attr, $data->{$attr->name}, $options);
    return if !defined($value);
    $self->storage->{$attr->name} = defined $value ? $value : return;
};

1;

__END__

=pod

=head1 NAME

MooseX::Storage::Traits::IgnoreUndefs - A custom trait that doesn't fully collapse an object if an attribute has no value, 
instead returns undef.

=head1 SYNOPSIS


    {   package Point;
        use Moose;
        use MooseX::Storage;

        with Storage( traits => [qw|IgnoreUndefs|] );

        has 'x' => (is => 'rw' );
        has 'y' => (is => 'rw' );
        has 'z' => (is => 'rw' );

    }

    my $p = Point->new( 'x' => 4 );

    # the result of ->pack will contain:
    # { x => 4, y => undef, z => undef }
    $p->pack;

=head1 DESCRIPTION

There are times when you still want the attribute names to be returned regardless if
they contain a value or not. If an attribute has no value it will populate it with undef.

=head1 METHODS

=head2 Introspection

=over 4

=item B<meta>

=back

=head1 BUGS

All complex software has bugs lurking in it, and this module is no
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 AUTHOR

Stevan Little E<lt>stevan.little@iinteractive.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2007-2008 by Infinity Interactive, Inc.

L<http://www.iinteractive.com>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
