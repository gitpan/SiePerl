#
# Copyright (C) 1998 Ken MacLeod
# XML::Grove::Visitor is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
#
# $Id: Visitor.pm,v 1.2 1998/04/11 15:42:30 ken Exp $
#

use strict;

package XML::Grove::Visitor;

package XML::Grove::_Common;

sub accept {
    my $self = shift;

    die "XML::Grove::Visitor: accept called on unsupported object of class \`"
	. ref ($self) . "'\n";
}

sub accept_name {
    my $self = shift;

    return $self->accept (@_);
}

# the following only work on elements, and the caller should know it,
# we may want these to die.

sub children_accept {
    # no action

    return ();
}

sub children_accept_name {
    # no action

    return ();
}

sub attr_accept {
    # FIXME should this die? this should never be called unless you
    # know the object you're visiting is an element
    # no action

    return ();
}

sub _children_accept {
    my $self = shift; my $array = shift; my $visitor = shift;

    my @return;
    my $ii;
    for ($ii = 0; $ii <= $#$array; $ii ++) {
	my ($child) = $array->[$ii];
	if (!ref ($child)) {
	    push @return, $visitor->visit_scalar ($child, @_);
	} else {
	    push @return, $child->accept ($visitor, @_);
	}
    }

    return @return;
}

sub _children_accept_name {
    my $self = shift; my $array = shift; my $visitor = shift;

    my @return;
    my $ii;
    for ($ii = 0; $ii <= $#$array; $ii ++) {
	my ($child) = $array->[$ii];
	if (!ref ($child)) {
	    push @return, $visitor->visit_scalar ($child, @_);
	} else {
	    push @return, $child->accept_name ($visitor, @_);
	}
    }
}

package XML::Grove::_Common::Iter;

sub accept {
    my $self = shift;

    die "XML::Grove::Visitor: accept called on unsupported object of class \`"
	. ref ($self) . "'\n";
}

sub accept_name {
    my $self = shift;
    return $self->accept (@_);
}

sub children_accept {
    # no action

    return ();
}

sub children_accept_name {
    # no action

    return ();
}

sub attr_accept {
    # no action

    return ();
}

sub _children_accept {
    my $self = shift; my $array = shift; my $visitor = shift;

    my @return;
    my $ii;
    for ($ii = 0; $ii <= $#$array; $ii ++) {
	my ($child) = $array->[$ii];
	if (!ref ($child)) {
	    my $iter = bless ([$child, $self, $array, $ii],
			      'XML::Grove::Scalar::Iter');
	    push @return, $visitor->visit_scalar ($iter, @_);
	} else {
	    my $iter = $child->iter ($self, $array, $ii);
	    push @return, $iter->accept ($visitor, @_);
	}
    }

    return @return;
}

sub _children_accept_name {
    my $self = shift; my $array = shift; my $visitor = shift;

    my @return;
    my $ii;
    for ($ii = 0; $ii <= $#$array; $ii ++) {
	my ($child) = $array->[$ii];
	if (!ref ($child)) {
	    my $iter = bless ([$child, $self, $array, $ii],
			      'XML::Grove::Scalar::Iter');
	    push @return, $visitor->visit_scalar ($iter, @_);
	} else {
	    my $iter = $child->iter ($self, $array, $ii);
	    push @return, $iter->accept_name ($visitor, @_);
	}
    }

    return @return;
}

package XML::Grove;

sub accept {
    my $self = shift;
    my $visitor = shift;

    return $visitor->visit_grove ($self, @_);
}

sub children_accept {
    my $self = shift;

    return $self->_children_accept ($self->contents, @_);
}

sub children_accept_name {
    my $self = shift;

    return $self->_children_accept_name ($self->contents, @_);
}

package XML::Grove::Iter;

sub accept {
    my $self = shift;
    my $visitor = shift;

    return $visitor->visit_grove ($self, @_);
}

sub children_accept {
    my $self = shift;

    return $self->_children_accept ($self->contents, @_);
}

sub children_accept_name {
    my $self = shift;

    return $self->_children_accept_name ($self->contents, @_);
}

package XML::Grove::Element;

sub accept {
    my $self = shift;
    my $visitor = shift;

    return $visitor->visit_element ($self, @_);
}

sub accept_name {
    my $self = shift;
    my $visitor = shift;

    my $name = $self->name;
    $name =~ s/\W/_/g;
    my $name_method = "visit_name_$name";
    return $visitor->$name_method ($self, @_);
}

sub children_accept {
    my $self = shift;

    return $self->_children_accept ($self->contents, @_);
}

sub children_accept_name {
    my $self = shift;

    return $self->_children_accept_name ($self->contents, @_);
}

sub attr_accept {
    my $self = shift; my $attr = shift; my $visitor = shift;

    my $attrs = $self->attr($attr);
    if (ref($attrs) eq 'ARRAY') {
	return $self->_children_accept ($attrs, $visitor, @_);
    } else {
	return $visitor->visit_scalar ($attrs, @_);
    }
}

package XML::Grove::Element::Iter;

sub accept {
    my $self = shift;
    my $visitor = shift;

    return $visitor->visit_element ($self, @_);
}

sub accept_name {
    my $self = shift;
    my $visitor = shift;

    my $name = $self->name;
    $name =~ s/\W/_/g;
    my $name_method = "visit_name_$name";
    return $visitor->$name_method ($self, @_);
}

sub children_accept {
    my $self = shift;

    return $self->_children_accept ($self->contents, @_);
}

sub children_accept_name {
    my $self = shift;

    return $self->_children_accept_name ($self->contents, @_);
}

sub attr_accept {
    my $self = shift; my $attr = shift; my $visitor = shift;

    my $attrs = $self->attr($attr);
    if (ref($attrs) eq 'ARRAY') {
	return $self->_children_accept ($attrs, $visitor, @_);
    } else {
	my $iter = bless ([$attrs, $self, undef, -1],
			  'XML::Grove::Scalar::Iter');
	return $visitor->visit_scalar ($iter, @_);
    }
}

package XML::Grove::Entity;

sub accept {
    my $self = shift;
    my $visitor = shift;

    return $visitor->visit_entity ($self, @_);
}

package XML::Grove::Entity::Iter;

sub accept {
    my $self = shift;
    my $visitor = shift;

    return $visitor->visit_entity ($self, @_);
}

package XML::Grove::PI;

sub accept {
    my $self = shift;
    my $visitor = shift;

    return $visitor->visit_pi ($self, @_);
}

package XML::Grove::PI::Iter;

sub accept {
    my $self = shift;
    my $visitor = shift;

    return $visitor->visit_pi ($self, @_);
}

package XML::Grove::Comment;

sub accept {
    my $self = shift;
    my $visitor = shift;

    return $visitor->visit_comment ($self, @_);
}

package XML::Grove::Comment::Iter;

sub accept {
    my $self = shift;
    my $visitor = shift;

    return $visitor->visit_comment ($self, @_);
}

1;

__END__

=head1 NAME

XML::Grove::Visitor - add visitor/callback methods to XML objects

=head1 SYNOPSIS

 use XML::Grove::Visitor;

 @results = $xml_object->accept ($visitor, ...);
 @results = $xml_object->accept_name ($visitor, ...);
 @results = $xml_object->children_accept ($visitor, ...);
 @results = $xml_object->children_accept_name ($visitor, ...);
 @results = $element->attr_accept ($attr, $visitor, ...);

=head1 DESCRIPTION

XML::Grove::Visitor adds visitor methods (callbacks) to XML objects
and their iterators.  A ``visitor'' is a class (a package) that has
methods (subs) corresponding to the objects in the classes being
visited.  You use the visitor methods by creating an instance of your
visitor class, and then calling `C<accept($my_visitor)>' on the
top-most object you want to visit, that object will in turn call your
visitor back with `C<visit_I<OBJECT>>', where I<OBJECT> is the type of
object.

There are several forms of `C<accept>'.  Simply calling `C<accept>'
calls your package back using the object type of the object you are
visiting.  Calling `C<accept_name>' on an element object calls you
back with `C<visit_name_I<NAME>>' where I<NAME> is the tag name of the
element, on all other objects it's as if you called `C<accept>'.

All of the forms of `C<accept>' return a concatenated list of the
result of all `C<visit>' methods.

`C<children_accept>' calls `C<accept>' on each of the children of the
element.  This is generally used in element callbacks to recurse down
into the element's children, you don't need to get the element's
contents and call `C<accept>' on each item.  `C<children_accept_name>'
does the same but calling `C<accept_name>' on each of the children.
`C<attr_accept>' calls `C<accept>' on each of the objects in the named
attribute.

If the child object you are visiting is a Perl scalar, you will be
called back with `C<visit_scalar>'.  The complete list of callbacks
defined by XML::Grove::Visitor are:

    visit_grove
    visit_element
    visit_entity
    visit_pi
    visit_comment
    visit_scalar

When using `C<accept>' methods with an iterator, the child objects you
get called back with will also be iterators, including
`C<visit_scalar>'.

See also the examples `C<visitor.pl>' and `C<my-html.pl>'.

=head1 HMM

These are random ideas that haven't been implemented yet:

=over 4

=item *

Some people like their subs a little simpler, i.e. drop the
`C<visit_>'.  In SGML::Grove, tag names were called back with the SGML
equivalent, `C<visit_gi_I<NAME>>' (generic identifier).  Both of these
could possibly be made into options.

=item *

Several objects fall into subclasses, or you may want to be able to
subclass a visited object and still be able to tell the difference.
In SGML::Grove I had used the package name in the callback
(`C<visit_SGML_Element>') instead of a generic name
(`C<visit_element>').  The idea here would be to try calling
`C<visit_I<PACKAGE>>' with the most specific class first, then try
superclasses, and lastly to try the generic.

=back

=head1 AUTHOR

Ken MacLeod, ken@bitsko.slc.ut.us

=head1 SEE ALSO

perl(1), XML::Parser(3), XML::Parser::Grove(3).

Extensible Markup Language (XML) <http://www.w3c.org/XML>

=cut
