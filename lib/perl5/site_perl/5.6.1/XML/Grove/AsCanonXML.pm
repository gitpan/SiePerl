#
# Copyright (C) 1998 Ken MacLeod
# XML::Grove::AsCanonXML is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
#
# $Id: AsCanonXML.pm,v 1.2 1998/09/09 19:05:46 ken Exp $
#

use strict;

package XML::Grove::AsCanonXML;
use vars qw{%char_entities};
use XML::Grove::Visitor;

%char_entities = (
    "\x09" => '&#9;',
    "\x0a" => '&#10;',
    "\x0d" => '&#13;',
    '&' => '&amp;',
    '<' => '&lt;',
    '>' => '&gt;',
    '"' => '&quot;',
);

sub new {
    my ($class, %args) = @_;

    my $self = \%args;
    return bless $self, $class;
}

sub as_canon_xml {
    my $self = shift; my $object = shift; my $fh = shift;

    if (defined $fh) {
	return ();
    } else {
	return join('', $object->accept($self, $fh));
    }
}

sub comments {
    my $self = shift;
    if (@_) {
	$self->{'comments'} = shift;
	return $self;
    } else {
	return $self->{'comments'};
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
    my $self = shift; my $element = shift; my $fh = shift;

    my @return;
    push @return, $self->_print($fh, '<' . $element->name);
    my $key;
    my $attrs = $element->attributes;
    foreach $key (sort keys %$attrs) {
	push @return, $self->_print($fh,
		      " $key=\"" . $self->_escape($attrs->{$key}) . '"');
    }
    push @return, $self->_print($fh, '>');

    push @return, $element->children_accept($self, $fh, @_);

    push @return, $self->_print($fh, '</' . $element->name . '>');

    return @return;
}

sub visit_entity {
    # entities don't occur in text
    return ();
}

sub visit_pi {
    my $self = shift; my $pi = shift; my $fh = shift;

    return $self->_print($fh, '<?' . $pi->target . ' ' . $pi->data . '?>');
}

sub visit_comment {
    my $self = shift; my $comment = shift; my $fh = shift;

    if ($self->{comments}) {
	return $self->_print($fh, '<!--' . $comment->data . '-->');
    } else {
	return ();
    }
}

sub visit_scalar {
    my $self = shift; my $scalar = shift; my $fh = shift;

    if (ref $scalar) {
	$scalar = $scalar->delegate;
    }

    return ($self->_print($fh, $self->_escape($scalar)));
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

sub _escape {
    my $self = shift; my $string = shift;

    $string =~ s/([\x09\x0a\x0d&<>"])/$char_entities{$1}/ge;
    return $string;
}

package XML::Grove::_Common;

sub as_canon_xml {
    my $xml_object = shift;

    return XML::Grove::AsCanonXML->new(@_)->as_canon_xml($xml_object);
}

1;

__END__

=head1 NAME

XML::Grove::AsCanonXML - output XML objects in canonical XML

=head1 SYNOPSIS

 use XML::Grove::AsCanonXML;

 $string = $xml_object->as_canon_xml OPTIONS;

 $writer = new XML::Grove::AsCanonXML OPTIONS;

 # OPTIONS
 $writer->comments([$bool]);

 $string = $writer->as_canon_xml($xml_object);
 $writer->as_canon_xml($xml_object, $file_handle);

=head1 DESCRIPTION

C<XML::Grove::AsCanonXML> will return a string or write a stream of
canonical XML for an XML object and it's content (if any).

C<XML::Grove::AsCanonXML> objects hold the options used for writing
the XML objects.  Options can be supplied when the the object is
created,

    $writer = new XML::Grove::AsCanonXML comments => 1;

or modified at any time before writing an XML object using the methods
defined below.

=head1 OPTIONS

=over 4

=item $writer->comments( [$bool] )

By default comments are not written to the output.  Setting comment to
TRUE will include comments in the output.

=back

=head1 AUTHOR

Ken MacLeod, ken@bitsko.slc.ut.us

=head1 SEE ALSO

perl(1), XML::Parser(3), XML::Grove(3).

James Clark's Canonical XML definition
<http://www.jclark.com/xml/canonxml.html>

=cut
