#
# Copyright (C) 1998 Ken MacLeod
# XML::Parser::Grove is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
#
# This module was derived in part from XML::Parser by Larry Wall.
#
# $Id: Grove.pm,v 1.2 1998/09/20 18:48:01 kmacleod Exp $
#

use strict;

package XML::Parser::Grove;

use XML::Parser;
use XML::Grove;
$XML::Parser::Built_In_Styles{Grove} = 1;

sub init {
    my $self = shift;
    $self->{Lists} = [];
    $self->{Curlist} = [];
    $self->{Grove} = new XML::Grove (contents => $self->{Curlist});
}

sub start {
    my $self = shift;
    my $tag = shift;
    my $contents = [ ];
    my $element = new XML::Grove::Element (name => $tag,
					   attributes => {@_},
					   contents => $contents);
    push @{ $self->{Lists} }, $self->{Curlist};
    push @{ $self->{Curlist} }, $element;
    $self->{Curlist} = $contents;
}

sub end {
    my $self = shift;
    my $tag = shift;
    $self->{Curlist} = pop @{ $self->{Lists} };
}

sub char {
    my $self = shift;
    my $text = shift;
    push @{ $self->{Curlist} }, $text;
}

sub proc {
    my $self = shift;
    my $target = shift;
    my $data = shift;
    push @{ $self->{Curlist} }, new XML::Grove::PI (target => $target,
						    data => $data);
}

sub final {
    my $self = shift;
    delete $self->{Curlist};
    delete $self->{Lists};

    return $self->{Grove};
}

1;
