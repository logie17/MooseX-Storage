package MooseX::Storage::Engine::Trait::WhiteListSerialization;
use Moose::Role;

around 'map_attributes' => sub {
    my ($orig, $self, $method_name, @args) = @_;
    map {
        $self->$method_name($_, @args)
    } grep {
        $_->does('MooseX::Storage::Meta::Attribute::Trait::Serialize')
    } ($self->_has_object ? $self->object : $self->class)->meta->get_all_attributes;
};

1;
