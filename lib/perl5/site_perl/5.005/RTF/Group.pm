package RTF::Group;

require 5.005;

use Carp;

use strict;
use vars qw($VERSION);

$VERSION = '0.23';

sub new
{
    my $this = shift;
    my $class = ref($this) || $this;
    my $self = {};
    bless $self, $class;
    $self->initialize();
    $self->import(@_);
    return $self;
}

# --- default user-settable properties

my %PROPERTIES = ( subgroup => 1, escape => 1, wrap => 0 );

sub initialize
{
    my $self = shift;

    $self->{GROUP} = [];

    foreach my $prop (keys %PROPERTIES)
    {
        $self->{$prop} = $PROPERTIES{$prop};
    }
}

sub import
{
    my $self = shift;
    foreach my $arg (@_)
    {
        if (ref($arg) eq "HASH")
        {
            foreach my $prop (keys %{$arg})
            {
                if (exists($PROPERTIES{$prop}))
                {
                    $self->{$prop} = ${$arg}{$prop};
                }
                else
                {
                    croak "Invalid property: \`$prop\'";
                }
            }
        }
        else {
            $self->append($arg);
        }
    }
}

sub append
{
    my $self = shift;
    push @{$self->{GROUP}}, @_;
}

# escape unescaped brackets and 8-bit chaacters
sub _escape
{
    local ($_) = shift;
    s/[!\\]?([\{\}])/\\$1/g;
    s/([\x80-\xff])/sprintf("\\\'\%02x", ord($1))/eg;
    return $_;
}

sub _list
{
    my $self = shift;
    my @list = ();

    my @parse = @_;
    unless (@parse)
    {
        return (), unless (defined($self->{GROUP}));
        @parse = @{$self->{GROUP}}
    };

    while (my $atom = shift @parse)
    {
        my $ref_atom = ref($atom);

        if ($ref_atom =~ m/^RTF::Group/)
        {
            if ($atom->{subgroup})
            {
                push @list, [ $atom->_list() ];
            }
            else
            {
                push @list, $atom->_list();
            }
        }
        elsif ($ref_atom eq "ARRAY")
        {
            push @list, $self->_list(@{$atom});
        }
	elsif ($ref_atom eq "CODE")
	{
            my $args = shift @parse;
            push @list, $self->_list( &{$atom}(@{$args}) );
	}
        elsif ($ref_atom eq "SCALAR")
        {
            push @list, ${$atom}, if (length(${$atom}));
        }
        elsif ($ref_atom eq "REF")
        {
	    push @list, $self->_list( ${$atom} );
        }  
        elsif ($ref_atom ne "")
        {
            croak "Cannot handle reference to $ref_atom";
        }
        else
        {
            push @list, $atom, if (length($atom));
        }
    }

    return @list;
}

sub _list_as_string
{
    my $self = shift;

    my ($atom, $string);

    unless (@_) {
        return undef;
    }

    $string = "\{";

    foreach $atom (@_)
    {
        my $ref_atom = ref($atom);

        if ($ref_atom eq "ARRAY")
        {
            $string .= $self->_list_as_string(@{$atom});
        }
        else
        {
	    $atom = _escape($atom), if ($self->{escape});

            if (($atom !~ m/^[\\\;\{\}]/) and ($string !~ m/[\}\{\s]$/))
            {
                $string .= " ";
            }
            $string .= $atom;
        }
    }
    $string .= "\}";
    return $string;
}

sub is_empty
{
    my $self = shift;
    return ($self->_list() == 0);
}

sub string
{
    my $self = shift;
    return $self->_list_as_string( $self->_list() );
}


1;
__END__

=head1 NAME

RTF::Group - Base class for manipulating Rich Text Format (RTF) groups

=head1 DESCRIPTION

This is a base class for manipulating RTF groups.  Groups are stored internally
as lists. Lists may contain (sub)groups or atoms (raw text or control words).

Unlike the behavior of groups in the original RTF::Document module (versions 0.63
and earlier), references to arrays (lists) are I<not> treated as subgroups, but
are dereferenced when expanded (as lists or strings).

This allows more flexibility for changing control codes within a group, without
having to know their exact location, or to use kluges like I<splice> on the
arrays.

=head1 METHODS

=head2 new

    $group = new RTF::Group LIST, PROPERTIES;

Creates a new group. If LIST is specified, it is appended to the group.
PROPERTIES are optional, and are used to set properties for the object.

By default, the C<subgroup> property is set.  This means that if the
group is appended to another group, it will be emitted (using the C<_list>
and C<string> methods) as a group within a group:

    $g1 = new RTF::Group(g1);
    $g2 = new RTF::Group(g2);
    $g1->append($g2);
    print $g1->string;         # emits '{g1{g2}}'

If we disable the C<subgroup> property, we get the following:

    $g1 = new RTF::Group(g1);
    $g2 = new RTF::Group(g2, {subgroup=>0});
    $g1->append($g2);
    print $g1->string;         # emits '{g1 g2}'

The C<escape> property enables automatic escaping of unescaped
curly brackets when a group is emitted as a string. (This property
is also enabled by default.)

The C<wrap> property is not used in this version.

See the C<append> method for more details on how groups are handled.

=head2 append

    $group->append LIST;

Appends LIST to the group. LIST may be plain text, controls, other groups, or
references to a SCALAR or another LIST.

If LIST contains another RTF::Group, it will be embedded as a subgroup
(how this is handled is explained in the the documentation for the C<new>
method).

If LIST contains a reference to a SCALAR, the value it points to will be
emitted when the C<_list()> or C<_string> methods are called.

If LIST contains a reference to CODE, the value that code returns will
be emitted as if it were returned by C<_list()>. For insance,

    sub generator
    {
        return 'g2';
    }

    $g1 = new RTF::Group(g1);
    $g1->append( \&generator, [] );
    print $g1->string();       # emits '{g1 g2}'

Note that C<\&generator> cannot have any arguments. However, the 
next argument in the list is a reference to a list of arguments.

=head2 string

    print $group->string();

Returns the group as a string that would appear in an RTF document.

=head2 is_empty

    if ($group->is_empty) { ... }

Returns true if the group is empty, false if it contains something. Zero-length
strings are considered nothing.

=head2 _list

    @RTF = $group->_list LIST;

"Parses" LIST by dereferencing scalars, arrays or subgroups. If LIST is
not specified, parses group. (Although this may useful for parsers, it is
intended for internal use I<(read: private method)>.)

=head2 _list_as_string

    $output = $group->_list_as_string( LIST )

Converts the output of the C<_list()> method into a string. This is a
private method and may go away in future versions: use the C<string>
method instead.

=head2 _escape

    $atom = RTF::Group::_escape( SCALAR );

Does simple RTF escaping of brackets and 8-bit characters.

=head1 SEE ALSO

Microsoft Technical Support and Application Note, "Rich Text Format (RTF)
Specification and Sample Reader Program", Version 1.5.

=head1 AUTHOR

Robert Rothenberg <wlkngowl@unix.asb.com>

=head1 LICENSE

Copyright (c) 1999-2000 Robert Rothenberg. All rights reserved.
This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut


