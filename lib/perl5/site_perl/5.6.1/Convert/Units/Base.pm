package Convert::Units::Base;
require 5.004;
require Exporter;

@ISA = qw(Exporter);

use vars qw($VERSION);

use Carp;

$VERSION = "0.43";

sub initialize {
    my $self = shift;
    $self->{default} 	= undef; 	# default unit
    $self->{conversions} 	= {};		# conversions
    $self->{synonyms} 	= {};		# unit synonyms and abbreviations
    $self->{multipliers} 	= {};		# multipliers
}

sub import {
    my $self = shift;

    my ($conversions, $synonyms, $multipliers, $default) = (@_);

    $self->{conversions} 	= $conversions;
    $self->{synonyms} 		= $synonyms;
    $self->{multipliers} 	= $multipliers;
    $self->{default} 		= $default;

    # if no default unit has been defined, look for any "base" unit

    unless (defined($self->{default}))
    {
        foreach (keys %{$self->{conversions}})
        {
            if (${$self->{conversions}}{$_}==1)
            {
                $self->{default} = $_;
            }
        }
    }

    # Add plural versions of unit names

    foreach (keys %{$self->{conversions}}) {
        ${$self->{conversions}}{$self->plural($_)} = ${$self->{conversions}}{$_};
    }

    foreach (keys %{$self->{multipliers}}) {
        ${$self->{multipliers}}{$self->plural($_)} = ${$self->{multipliers}}{$_};
    }

    # Add synonyms and abbreviations for units

    foreach (keys %{$self->{synonyms}}) {
        ${$self->{conversions}}{$_} = ${$self->{conversions}}{${$self->{synonyms}}{$_}};
    }
}

sub new {
    my $this = shift;
    my $class = ref($this) || $this;
    my $self = {};
    bless $self, $class;
    $self->initialize();
    $self->import(@_);
    return $self;
}

# In the future use Lingua::EN::Inflect?

sub plural
{
    my $self = shift;

    local ($_) = shift;

    my $suff = "s";
    
    $suff = "es",	 if (m/(ch|s)$/);
    $suff = "ies", if (m/y$/);

    $_ .= $suff;

    $_ = "halves", if ($_ eq "halfs");	# exceptions
    $_ = "feet",   if ($_ eq "foots");

    return $_;
}

sub parse_unit
{
    my $self = shift;

    local ($_) = shift;
    my $base = shift;	# assume no number specfied = base (0 or 1 usually)

    m/^(\-?\d*(\.\d+)?)\s*(\D*)$/;

    my $number = $1 || $base;
    my $unit   = $3 || $self->{default};

    unless (defined(${$self->{conversions}}{$unit}))
    {
        if ($unit =~ m/(\w+)([\s\-]of[\s\-]an?|[\s\-]of)?[\s\-](\w+)$/)
        {
            $number *= ${$self->{multipliers}}{$1};
            $unit = $3;
        }
    }

    unless (defined(${$self->{conversions}}{$unit}))
    {
        croak "Invalid unit: $unit";
    }

    return ($number, $unit);
}

sub convert_units
{
    my $self = shift;

    my ($amount, $unit) 	= $self->parse_unit (shift, 0);
    my ($multiple, $unit_to) 	= $self->parse_unit (shift, 1);
   
    unless (defined($unit_to)) {
        $unit_to = $self->{default};
    }

    my ($M, $A);
    my $U = ${$self->{conversions}}{$unit};

    if (ref($U) eq ARRAY) {
        ($M, $A) = @{$U};
    } else {
        $M = $U;
        $A = 0;
    }

    my $def_unit 	= ($amount + $A) * $M;

    $U = ${$self->{conversions}}{$unit_to};
    if (ref($U) eq ARRAY) {
        ($M, $A) = @{$U};
    } else {
        $M = $U;
        $A = 0;
    }

    my $result 	= (($def_unit / $M) - $A) / $multiple;

    return $result;
}

sub parse_string
{
    my $self = shift;
    my $str = lc(shift);
    my $unit_to = lc(shift);

    my $sum = 0, $el = "1";

    my @units = (split /,|\s+/, $str);

    foreach my $unit (@units) {

        $el = $unit, if ($unit =~ m/^\d/);
        $el .= " ".$unit, if (($unit =~ m/^\D/) and ($unit !~ m/^(and)$/));

        if ($el =~ m/\d\D/) {
            $sum += $self->convert_units ($el, $unit_to);
            $el = "1";
        }
    }

    return $sum;
}


1;

__END__

=head1 NAME

Convert::Units::Base - base object for performing unit conversions

=head1 DESCRIPTION

The Units package is a collection of modules for parsing strings with
unit measurements (such as "12pt" or "3 meters") and converting them
to some other unit (such as "picas" or "inches").

It uses a base package (Units::Base) which does the dirty work. Other
modules define what units they handle and how they are related.

=head2 Why a Separate Module?

It is I<intentionally> distinct from the I<Math::Units> module. Why? The
I<Math::Units> module implies that unit conversions are I<exact>,
with one-to-one relationships.  This is fine for scientific work.
It's even fine for some general purpose/real-world uses (such as
converting Fehrenheight to Celcius).

Real-world measurement systems are conflicting. For instance, a "point"
in typography is equivalent to 1/72 inch, according to PostScript specs
and common usage. Other type systems consider it 1/72.27 inch, or 0.01383
inches, or 0.0148 inches.  Outside of that context, a point may be 1/120
or 1/144 inch.

Common notations and abbreviations also depend on context. Does "12 pt"
mean "12 point", "12 parts" or "12 pints"?

Even without conflicts in the definition of a particular unit, there's no
need to convert point sizes for fonts into miles or light-years. Typesetters,
surveyors and astronomers user different scales as well as systems.

=head2 People do not think like computers

Not everyone uses the metric system.

And even less people say things like "5.25 feet". Often it's "5 feet, 3 inches"
or "5 1/4 feet".

Despite having ten fingers and toes, people don't think in tens. They think in
twos, threes, fours, twelves, and sixteens. And sometimes they use fractional
measurements like quarter-inches, sixteenths-of-an-inch, or half-pints.

The purpose of this module is to allow people to use the measurement
systems they are familiar with, and that is appropriate to what they
are doing.

=head2 Rationale

The Units:: hierarchy is an attempt to keep measurement systems in
distinct classes. Thus one can have modules for converting between
typography units (points, picas) distinct from common units of length
(or area, temperature, etc.), specialized units (for Astronomy, Chemistry,
Physics, Textiles, Winery, Navigation, etc.) or even traditional or
regional systems (Japanese, Chinese, Egyptian, archaic systems, etc.)
and to keep conflicting measurement systems distinct.

=head2 Release Notes

The current distribution contains the following packages:

    Convert::Units::
    ::Base         - a base module that does all of the work
    ::Length       - a module for converting units of length
    ::Temperature  - a module for converting units of temperature
    ::Type         - a module for converting units of type

Units::Base by itself does nothing. Another module needs to use it
to create definitions of what units of measurement it handles and
how they are related to each other (ie, 1 m = 100 cm).

The base unit also allows for synonym and abbreviations to be
defined.

It also allows common "multiples" to be defined, so that it can
handle things like "18 half-points" or "6 dozen feet" or even
convert millimters to "sixteenths of an inch". (It does not yet
handle Greek prefixes like centi- or mega- ... those will have
to be manually defined.)

=head2 Known Issues

The current release should be considered "beta" until further testing
and refinements have been made. Then again, maybe "alpha" is more
accurate.

The current version does not yet handle fractions such as "1/2 in".
It should handle decimals such as "0.5 in".

Relationships have been rewritten to be handle A(x+b) as well Ax.
They may be redone in the future to handle more complex
relationships, if the need arises.

Unit names much be defined as all lowercase, since strings are
munged with I<lc()> before processing. In other words, if you define
a unit name as "F" or "Fahrenheight" you won't be able to use it.

=head2 Future Enhancements

Aside from bug fixes, optimizations, and making the string parsing
conform more to the "manifesto" above, obvious additions would be modules
for converting between units of area, volume, weight... (although if
I<Math::Units> does what you need, use that instead.)

An example hierarchy for future modules:

    Convert::Units::
    ::Length		- general measures of length
    ::Area
    ::Pressure
    ::Volume

    Convert::Units::Length
    ::Chinese		- specialized regional/traditional systems
    ::English

    Convert::Units::Astronomy
    ::Length		- or Distance...?

Modules should share a common unit (preferably metric) to allow for
conversions.

=head1 REQUIRED MODULES

    Carp

=head1 SEE ALSO

I<Units::Length>, I<Units::Temperature> and I<Units::Type> modules, which
demonstrate how I<Units::Base> is used.

=head1 AUTHOR

Robert Rothenberg <wlkngowl@unix.asb.com>

=head1 LICENSE

Copyright (c) 1999-2000 Robert Rothenberg. All rights reserved.
This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.


=cut
