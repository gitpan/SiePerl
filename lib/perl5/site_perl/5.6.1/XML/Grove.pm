#
# Copyright (C) 1998 Ken MacLeod
# XML::Grove is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
#
# $Id: Grove.pm,v 1.6 1998/09/20 18:48:01 kmacleod Exp $
#

use strict;

# XML::Grove::_Common is not a real abstract class, it is simply a
# placeholder for what little *can* be shared among the objects, as
# well as a place for iterators and tree walkers to add methods that
# would make traversal easier.

package XML::Grove::_Common;

sub new {
    my $class = shift;
    my ($self) = ($#_ == 0) ? shift : {@_};

    return bless $self, $class;
}

###################################################################

# The ``Grove'' is the holder of the root of the document entity.
# Note that processing instructions (XML::PI objects) can come before
# or after the root element, so Grove has a `contents' variable and
# asking for `root' gives the XML::Element object in `contents' and
# setting `root' overwrites all of `contents' with a new content just
# containing `root'.

package XML::Grove;
use vars qw{@ISA $VERSION};
@ISA = qw{XML::Grove::_Common};
$VERSION = '0.05';

sub root {
    my $self = shift;
    if (@_) {
	return $self->{'contents'} = [ shift ];
    } else {
	my $content;
	foreach $content (@{ $self->{'contents'} }) {
	    # FIXME use isa
	    return $content if (ref ($content) =~ /Element/);
	}
    }
}

sub notations {
    my $self = shift;
    @_ ? ($self->{'errors'} = shift) : $self->{'notations'};
}

sub entities {
    my $self = shift;
    @_ ? ($self->{'errors'} = shift) : $self->{'entities'};
}

sub contents {
    my $self = shift;
    @_ ? ($self->{'contents'} = shift) : $self->{'contents'};
}

###################################################################

# The `contents' of an Element may contain elements
# (XML::Grove::Element), character data (Perl scalars), entity
# references (classes of XML::Grove::Entity), character references
# (TBD), processing instructions (XML::Grove::PI), and comments (TBD,
# XML::Grove::Comment).

package XML::Grove::Element;
use vars qw{@ISA};
@ISA = qw{XML::Grove::_Common};

sub name {
    my $self = shift;
    @_ ? ($self->{'name'} = shift) : $self->{'name'};
}

sub attributes {
    my $self = shift;
    @_ ? ($self->{'attributes'} = shift) : $self->{'attributes'};
}

sub contents {
    my $self = shift;
    @_ ? ($self->{'contents'} = shift) : $self->{'contents'};
}

sub attr {
    my $self = shift;
    my $attr = shift;
    @_ ? ($self->{'attributes'}{$attr} = shift)
	: $self->{'attributes'}{$attr};
}

###################################################################

package XML::Grove::Entity;
use vars qw{@ISA};
@ISA = qw{XML::Grove::_Common};

sub name {
    my $self = shift;
    @_ ? ($self->{'name'} = shift) : $self->{'name'};
}

sub data {
    my $self = shift;
    @_ ? ($self->{'data'} = shift) : $self->{'data'};
}

###################################################################

package XML::Grove::Entity::External;
use vars qw{@ISA};
@ISA = qw{XML::Grove::Entity};

sub type {
    my $self = shift;
    @_ ? ($self->{'data'} = shift) : $self->{'data'};
}

sub system_id {
    my $self = shift;
    @_ ? ($self->{'data'} = shift) : $self->{'data'};
}

sub public_id {
    my $self = shift;
    @_ ? ($self->{'data'} = shift) : $self->{'data'};
}

sub generated_id {
    my $self = shift;
    @_ ? ($self->{'data'} = shift) : $self->{'data'};
}

sub attributes {
    my $self = shift;
    @_ ? ($self->{'data'} = shift) : $self->{'data'};
}

sub notation {
    my $self = shift;
    @_ ? ($self->{'data'} = shift) : $self->{'data'};
}

###################################################################

package XML::Grove::PI;
use vars qw{@ISA};
@ISA = qw{XML::Grove::_Common};

sub target {
    my $self = shift;
    @_ ? ($self->{'target'} = shift) : $self->{'target'};
}

sub data {
    my $self = shift;
    @_ ? ($self->{'data'} = shift) : $self->{'data'};
}

###################################################################

package XML::Grove::Comment;
use vars qw{@ISA};
@ISA = qw{XML::Grove::_Common};

sub data {
    my $self = shift;
    @_ ? ($self->{'data'} = shift) : $self->{'data'};
}

1;

__END__

=head1 NAME

XML::Grove - simple, non-validating XML objects

=head1 SYNOPSIS

 use XML::Parser;
 use XML::Parser::Grove;
 use XML::Grove;

 $parser = XML::Parser->new(Style => 'grove');
 $grove = $parser->parsefile ($xml_file);

 # All methods may also take a value to set the corresponding
 # property

 # XML::Grove
 $root = $grove->root;            # the one element in `contents'
 $entities = $grove->entities;    # an array of entity defs
 $notations = $grove->notations;  # an array of notation defs
 $contents = $grove->contents;    # may include PIs and comments

 # XML::Grove::Element
 $name = $element->name;
 $attributes = $element->attributes;    # a hash
 $contents = $element->contents;        # an array
 $value = $element->attr ($attr_name);  # an array or scalar

 # XML::Grove::Entity
 $name = $entity->name;
 $data = $entity->data;

 # XML::Grove::PI
 $target = $pi->target;
 $data = $pi->data;

 # XML::Grove::Comment
 $data = $comment->data;

=head1 DESCRIPTION

C<XML::Grove> provides simple objects for parsed XML documents.  The
objects may be modified but no checking is performed by C<XML::Grove>.
C<XML::Grove> objects do not include parsing information such as
character positions or type of tags used.

The `C<contents>' of an XML::Grove contains the root element possibly
intermixed with processing instructions (PIs) or comments.

The `C<contents>' of an XML::Grove::Element may contain elements
(XML::Grove::Element), character data (Perl scalars), entity
references (TBD, classes of XML::Grove::Entity), character references
(TBD), processing instructions (XML::Grove::PI), and comments
(XML::Grove::Comment).

The `C<attributes>' of an XML::Grove::Element is an hash keyed by the
attribute name, each attribute is either an array that may contain
Perl scalars and entity references, or simply a Perl scalar.

To Be Determined (TBD): XML::Grove will be expanded to support
additional objects and features of XML::Parser and SGML::SP::Generic
as they become available.  XML::Grove is intended to remain a simple
module, other modules will be used to, for example, provide more
parsing info, perform validation while modifying, or be able to write
the same file that was read.  XML::Grove and SGML::Grove should be
nearly interchangeable.

=head1 AUTHOR

Ken MacLeod, ken@bitsko.slc.ut.us

=head1 SEE ALSO

perl(1), XML::Parser(3), XML::Parser::Grove(3).

Extensible Markup Language (XML) <http://www.w3c.org/XML>

=cut
