package Convert::Units::Length;
require 5.004;
require Exporter;

use vars qw($VERSION $self);
$VERSION = "0.14";

use Convert::Units::Base;

my $self = new Convert::Units::Base
  (
# The actual units, relative to each other (in this case, in inches)
    {
       'centimeter'	=> 0.3937,
        'decameter'	=> 393.7,
        'decimeter'	=> 3.937,
             'foot'	=> 12,
       'hectometer'	=> 3937,
             'inch'	=> 1,
        'kilometer'	=> 39370,
            'meter'	=> 39.37,
       'micrometer'	=> 0.00003937,
             'mile'	=> 63360,
       'millimeter' => 0.03937,
             'yard' => 36
    },
# Synonyms and abbreviations for these units
    {
                'm'	=> 'meter',
               'cm'	=> 'centimeter',
               'dm'	=> 'decimeter',
               'km'	=> 'kilometer',
               'mm'	=> 'millimeter',
           'micron'	=> 'micrometer',
               'mi'	=> 'mile',
               'ft'	=> 'foot',
             "\'" => 'foot',
               'in'	=> 'inch',
		"\"" => 'inch',
               'yd'	=> 'yard',
                'y'	=> 'yard'
    },
# Mulipliers (so we can say "dozen inches" or "sixteenths of an inch")
    {
            'dozen'       => 12,
        'quadruple'	=> 4,
           'triple'	=> 3,
           'double'	=> 2,
            'whole'	=> 1,
             'half'	=> 1/2,
            'third'	=> 1/3,
          'quarter'	=> 1/4,
           'eighth'	=> 1/8,
           'twelth'	=> 1/12,
        'sixteenth'	=> 1/16,
            'tenth'	=> 1/10,
        'twentieth'	=> 1/20,
         'fiftieth'	=> 1/50,
         'hundreth'	=> 1/100,
           'single'	=> 1
    },
# The default unit to convert to (when none is specified)
    "inch"
);


# A stub for converting units
sub convert
{
    return $self->convert_units (@_);
}

# A stub for parsing strings (such as "1 foot, 3 inches")
sub parse
{
    return $self->parse_string (@_);
}

1;

__END__
