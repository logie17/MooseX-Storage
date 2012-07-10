package MooseX::Storage::Traits::WhiteListSerialization;
use Moose::Role;

our $VERSION   = '0.31';

requires 'pack';
requires 'unpack';

around 'pack' => sub {
    my ($orig, $self, %args) = @_;
    $args{engine_traits} ||= [];
    push(@{$args{engine_traits}}, 'WhiteListSerialization');
    $self->$orig(%args);
};

around 'unpack' => sub {
    my ($orig, $self, $data, %args) = @_;
    $args{engine_traits} ||= [];
    push(@{$args{engine_traits}}, 'WhiteListSerialization');
    $self->$orig($data, %args);
};

no Moose::Role;

1;
