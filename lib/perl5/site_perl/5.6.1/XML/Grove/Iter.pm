#
# Copyright (C) 1998 Ken MacLeod
# XML::Grove::Iter is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
#
# $Id: Iter.pm,v 1.3 1998/09/09 19:05:46 ken Exp $
#

#
#  Internally, an XML::Grove::Iter is an array,
#
#    [0] -- delegate
#    [1] -- parent iterator
#    [2] -- parent's array
#    [3] -- current index
#
# FIXME there is a design error inherent here.  We shouldn't know that
# the parent's container for our object is an array and has an index.
# We should probably create a parent-specific iterator and then
# forward iterator methods there.  There's danger there too, ::Iter is
# implemented as a proxy, one proxy object for every iterated object,
# new proxies are generated for each movement, but can a ``normal''
# iterator handle that?  Note also that the array may be the parent's
# contents or an attribute of the parent.
#
# A good example of this is how scalar attributes are handled.
# Instead of a an index of `-1' we could use an iterator subclass that
# represents a item not in an array.

#
# There's a slight bit of misleading going on here, this package's
# name is `XML::Grove::Iter' but that's the class of the `XML::Grove'
# object's iterator.  The ``real'' bulk of this module is in the
# `XML::Grove::_Common::Iter' package and, just by coincidence,
# `XML::Grove::Iter' is defined too to satisfy Perl's package loading
# function.
#

use strict;

package XML::Grove::_Common::Iter;
use vars qw{$AUTOLOAD};

sub parent {
    # $self->{parent}
    return $_[0]->[1];
}

# Hmm... any chance we could be tricky here and have
# $iter->contents return a tied array so
#
#    foreach $item ($iter->contents) {
#    }
#
# would work as expected?
#
sub first_child {
    my $self = shift;

    #              $self->{delegate}->contents
    my $contents = $self->[0]->contents;

    return undef
	if (!defined $contents || $#$contents == -1);

    my $child = $contents->[0];
    if (ref $child) {
	return $child->iter ($self, $contents, 0);
    } else {
	return bless ([$child, $self, $contents, 0],
		      'XML::Grove::Scalar::Iter');
    }
}

sub last_child {
    my $self = shift;

    #              $self->{delegate}->contents
    my $contents = $self->[0]->contents;

    return undef
	if (!defined $contents || $#$contents == -1);

    my $child = $contents->[-1];
    if (ref $child) {
	return $child->iter ($self, $contents, $#$contents);
    } else {
	return bless ([$child, $self, $contents, $#$contents],
		      'XML::Grove::Scalar::Iter');
    }
}

sub is_iter {
    return 1;
}

sub root {
    #      $self if !defined $self->{parent}
    return $_[0]
	if !defined $_[0]->[1];

    # $self->{parent}->root;
    return $_[0]->[1]->root;
}

sub rootpath {
    #           $self->{parent}
    if (defined $_[0]->[1]) {
	#       $self->{parent}->rootpath, $self
	return ($_[0]->[1]->rootpath, $_[0]);
    } else {
	#       $self
	return ($_[0]);
    }
}

# return a new proxy for the next object
sub next {
    my ($delegate, $parent, $contents, $index) = @{$_[0]};

    # $index is -1 if scalar attribute
    return undef
	if ($index == -1 || $index == $#$contents);

    my $next = $contents->[$index+1];
    if (ref $next) {
	return $next->iter ($parent, $contents, $index+1);
    } else {
	return bless ([$next, $parent, $contents, $index+1],
		      'XML::Grove::Scalar::Iter');
    }
}

# return a new proxy for the next object
sub previous {
    my ($delegate, $parent, $contents, $index) = @{$_[0]};

    # $index is -1 if scalar attribute
    return undef
	if ($index == -1 || $index == 0);

    my $previous = $contents->[$index-1];
    if (ref $previous) {
	return $previous->iter ($parent, $contents, $index-1);
    } else {
	return bless ([$previous, $parent, $contents, $index-1],
		      'XML::Grove::Scalar::Iter');
    }
}

sub at_last {
    #       $self->{index} == -1
    #       || $self->{index} == $#{$self->{contents}}
    return ($_[0][3] == -1
	    || $_[0][3] == $#{$_[0][2]});
}

sub at_first {
    #       $self->{index} == -1 || $self->{index} == 0
    return ($_[0][3] == -1 || $_[0][3] == 0);
}

# `is_same' returns true if the two iterators are pointing to the same
# object or if our delegate *is* the object
sub is_same {
    my $self = shift;
    my $obj = shift;

    #       $self->{delegate}
    return ($self->[0] == $obj
	    || (ref ($self) eq ref ($obj)
		&& $self->[0] == $obj->[0]));
}

sub delegate {
    #      $self->{delegate}
    return $_[0]->[0];
}

sub AUTOLOAD {
    my ($class, $method) = ($AUTOLOAD =~ m/(.*::)(.*)/);

    return if $method eq 'DESTROY';

    # FIXME support methods that take the iterator as self
    my $self = shift;
    @{$self}[0]->$method (@_);
}

package XML::Grove::_Common;

sub is_iter {
    return 0;
}

sub iter {
    my $self = shift;
    my $parent = shift;
    my $contents = shift;
    my $index = shift;

    # FIXME create `$contents' if not passed to us

    return bless ([$self, $parent, $contents, $index],
		  ref ($self) . "::Iter");
}

package XML::Grove;
package XML::Grove::Iter;
use vars qw{@ISA};
@ISA = qw{XML::Grove::_Common::Iter};

package XML::Grove::Element;
package XML::Grove::Element::Iter;
use vars qw{@ISA};
@ISA = qw{XML::Grove::_Common::Iter};

sub attr_first {
    my $self = shift;
    my $attr = shift;

    my $contents = $self->[0]->attr($attr);

    return undef if (!defined $contents);

    if (ref($contents) eq 'ARRAY') {
	return undef if ($#$contents == -1);

	my $child = $contents->[0];
	if (ref $child) {
	    return $child->iter ($self, $contents, 0);
	} else {
	    return bless ([$child, $self, $contents, 0],
			  'XML::Grove::Scalar::Iter');
	}
    } else {
	return bless ([$contents, $self, undef, -1]);
    }
}

sub attr_last {
    my $self = shift;
    my $attr = shift;

    my $contents = $self->[0]->attr($attr);

    return undef
	if (!defined $contents);

    if (ref($contents) eq 'ARRAY') {
	return undef if ($#$contents == -1);

	my $child = $contents->[-1];
	if (ref $child) {
	    return $child->iter ($self, $contents, $#$contents);
	} else {
	    return bless ([$child, $self, $contents, $#$contents],
			  'XML::Grove::Scalar::Iter');
	}
    } else {
	return bless ([$contents, $self, undef, -1]);
    }
}

package XML::Grove::Entity;
package XML::Grove::Entity::Iter;
use vars qw{@ISA};
@ISA = qw{XML::Grove::_Common::Iter};

package XML::Grove::PI;
package XML::Grove::PI::Iter;
use vars qw{@ISA};
@ISA = qw{XML::Grove::_Common::Iter};

package XML::Grove::Comment;
package XML::Grove::Comment::Iter;
use vars qw{@ISA};
@ISA = qw{XML::Grove::_Common::Iter};

package XML::Grove::Scalar::Iter;
use vars qw{@ISA};
@ISA = qw{XML::Grove::_Common::Iter};

1;

__END__

=head1 NAME

XML::Grove::Iter - add tree iteration methods to XML objects

=head1 SYNOPSIS

 use XML::Grove::Iter;

 $iter = $xml_object->iter;

 $iter2 = $iter->parent;
 $iter2 = $iter->next;
 $iter2 = $iter->previous;

 $iter2 = $element_iter->first_child;
 $iter2 = $element_iter->last_child;
 $iter2 = $element_iter->attr_first ($attr);
 $iter2 = $element_iter->attr_last ($attr);

 $obj = $iter->delegate;
 $root = $iter->root;
 @path = $iter->rootpath;

 $bool = $iter->is_iter;
 $bool = $iter->is_same ($obj);
 $bool = $iter->at_last;
 $bool = $iter->at_first;

=head1 DESCRIPTION

XML::Grove::Iter is a proxy-based tree iterator.  ``Proxy based''
means that the iterator ``stands in'' for the real object and is used
as you would normally use the real object.  The iterator handles
moving around the tree and forwards all other methods to the real
object.

`C<parent>' returns the parent iterator of this iterator, or
`C<undef>' if this is the root iterator.  `C<next>' and `C<previous>'
return the iterator of the next object or the previous object,
respectively, in the parent's content (the sibling objects), or
`C<undef>' if there is no next or previous sibling.

`C<first_child>' and `C<last_child>' return the iterator of the first
child or the last child of the contents of this element or document.
`C<attr_first>' and `C<attr_last>' return the iterator of the first
child or last child of the named attribute.  These all return
`C<undef>' if the contents are empty.

`C<delegate>' returns the object that this iterator stands-in for,
``the delegate''.

`C<root>' returns the iterator of the top-most object of the sub-tree
being iterated.  Note that this may not be the root of the document
tree if the first iterator was created using a nested object.

`C<rootpath>' returns a list of the parent iterators between and
including the root and this iterator.

`C<is_iter>' returns true if this object is an iterator.  Ordinary XML
objects have been extended with an `C<is_iter>' method that returns
false.

`C<is_same>' returns true if `C<$obj>' is this iterator's delegate, or
if `C<$obj>' is an iterator that points to the same delegate.

`C<at_last>' and `C<at_first>' return true if calling `C<next>' or
`C<previous>', respectively, would return `C<undef>'.  Or in other
words, they return true if this iterator is at the end or the
beginning of the parent element's content.

=head1 AUTHOR

Ken MacLeod, ken@bitsko.slc.ut.us

=head1 SEE ALSO

perl(1), XML::Parser(3), XML::Parser::Grove(3).

Extensible Markup Language (XML) <http://www.w3c.org/XML>

=cut
