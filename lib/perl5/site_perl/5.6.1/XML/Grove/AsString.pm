#
# Copyright (C) 1998 Ken MacLeod
# XML::Grove::AsString is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
#
# $Id: AsString.pm,v 1.2 1998/04/11 15:42:30 ken Exp $
#

use strict;

package XML::Grove::AsString;
use XML::Grove::Visitor;

sub new {
    my ($class, %args) = @_;

    my $self = \%args;
    return bless $self, $class;
}

sub as_string {
    my $self = shift; my $object = shift; my $fh = shift;

    if (defined $fh) {
	return ();
    } else {
	return join('', $object->accept($self, $fh));
    }
}

sub filter {
    my $self = shift;
    if (@_) {
	$self->{'filter'} = shift;
	return $self;
    } else {
	return $self->{'filter'};
    }
}

sub entity_map {
    my $self = shift;
    if (@_) {
	$self->{'entity_map'} = shift;
	return $self;
    } else {
	return $self->{'entity_map'};
    }
}

sub entity_map_options {
    my $self = shift;
    if (@_) {
	$self->{'entity_map_options'} = shift;
	return $self;
    } else {
	return $self->{'entity_map_options'};
    }
}

sub entity_map_filter {
    my $self = shift;
    if (@_) {
	$self->{'entity_map_filter'} = shift;
	return $self;
    } else {
	return $self->{'entity_map_filter'};
    }
}

sub visit_document {
    my $self = shift; my $document = shift;

    return $document->children_accept($self, @_);
}

sub visit_grove {
    my $self = shift; my $document = shift;

    return $document->children_accept($self, @_);
}

sub visit_element {
    my $self = shift; my $element = shift;

    return $element->children_accept($self, @_);
}

sub visit_entity {
    my $self = shift; my $entity = shift; my $fh = shift;

    my $mapper = $self->{'entity_map'};
    return '' if (!defined $mapper);

    my $mapping;
    if (ref($mapper) eq 'CODE') {
	$mapping = &$mapper($entity->data,
			    $self->{'entity_map_options'});
    } else {
	$mapping = $mapper->lookup($entity->data,
				   $self->{'entity_map_options'});
    }

    if ($self->{'entity_map_filter'}) {
	my $filter = $self->{'filter'};
	if (defined $filter) {
	    $mapping = &$filter($mapping);
	}
    }

    return $self->_print($fh, $mapping);
}

sub visit_pi {
    return ();
}

sub visit_comment {
    return ();
}

sub visit_scalar {
    my $self = shift; my $scalar = shift; my $fh = shift;

    if (ref $scalar) {
	$scalar = $scalar->delegate;
    }

    if (defined ($self->{'filter'})) {
	$scalar = &{$self->{'filter'}}($scalar);
    }

    return $self->_print($fh, $scalar);
}

sub _print {
    my $self = shift; my $fh = shift; my $string = shift;

    if (defined $fh) {
	$fh->print($string);
	return ();
    } else {
	return ($string);
    }
}

package XML::Grove::_Common;

sub as_string {
    my $xml_object = shift;

    return XML::Grove::AsString->new(@_)->as_string($xml_object);
}

package XML::Grove::Element;

sub attr_as_string {
    my $element = shift; my $attr = shift;

    my $writer = new XML::Grove::AsString (@_);
    return $element->attr_accept ($attr, $writer);
}

1;

__END__

=head1 NAME

XML::Grove::AsString - output content of XML objects as a string

=head1 SYNOPSIS

 use XML::Grove::AsString;

 $string = $xml_object->as_string OPTIONS;
 $string = $element->attr_as_string $attr, OPTIONS;

 $writer = new XML::Grove::AsString OPTIONS;

 # OPTIONS
 $writer->filter([ \&callback ]);
 $writer->entity_map([ \&callback ]);
 $writer->entity_map([ $mapper ]);
 $writer->entity_map_options([ \%options ]);
 $writer->entity_map_filter([ $bool ]);

 $string = $writer->as_string($xml_object);
 $writer->as_string($xml_object, $file_handle);

=head1 DESCRIPTION

Calling `C<as_string>' on an XML object returns the character data
contents of that object as a string, including all elements below that
object.  Calling `C<attr_as_string>' on an element returns the
contents of the named attribute as a string.  Comments, processing
instructions, and, by default, entities all return an empty string.

I<OPTIONS> may either be a key-value list or a hash containing the
options described below.  The default options are no filtering and
entities are mapped to empty strings.

=head1 OPTIONS

This list summarizes the options available for `C<as_string>':

    filter => sub to filter character data
    entity_map => an object or sub to map character entities
    entity_map_options => options passed to entity_map
    entity_map_filter => true to use filter on mapped entities

`C<filter>' is an anonymous sub that gets called to process character
data before it is appended to the string to be returned.  This can be
used, for example, to escape characters that are special in output
formats.  `C<entity_map_filter>' is a flag to indicate if mapped
entities should be filtered after mapping.  `C<filter>' is called like
this:

    $string = &$filter ($character_data);

`C<entity_map>' is an object that accepts `C<lookup>' methods or an
anonymous sub that gets called with the entity replacement text (data)
and mapper options as arguments and returns the corresponding
character replacements.  It is called like this:

    $replacement_text = $entity_map->lookup ($entity_data,
					     $entity_map_options);

or this:

    $replacement_text = &$entity_map ($entity_data,
				      $entity_map_options);

`C<entity_map_options>' is passed through to the `C<lookup>' method,
the type of value is defined by the entity mapping package or the
anonymous sub.

=head1 EXAMPLES

Here is an example of entity mapping using the Text::EntityMap module:

    use Text::EntityMap;
    use XML::Grove::AsString;

    $html_iso_dia = Text::EntityMap->load ('ISOdia.2html');
    $html_iso_pub = Text::EntityMap->load ('ISOpub.2html');
    $html_map = Text::EntityMap->group ($html_iso_dia,
					$html_iso_pub);

    $element->as_string (entity_map => $html_map);

=head1 AUTHOR

Ken MacLeod, ken@bitsko.slc.ut.us

=head1 SEE ALSO

perl(1), XML::Parser(3), XML::Parser::Grove(3).

Extensible Markup Language (XML) <http://www.w3c.org/XML>

=cut
