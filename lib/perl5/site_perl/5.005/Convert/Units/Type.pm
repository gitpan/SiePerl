package Convert::Units::Type;
require 5.004;
require Exporter;

use vars qw($VERSION $self);
$VERSION = "0.34";

use Convert::Units::Base;

my $self = new Convert::Units::Base
  (
# The actual units, relative to each other (in this case, in inches)
    {
             'inch'	=> 1,
             'pica'	=> 1/6,	# PostScript (Anglo/Am 0.166in)
            'point' => 1/72,	# PostScript (Anglo/Am 0.01383in, Europe 0.0148in. 72.27pts/in??)
             'twip'	=> 1/1440,
       'centimeter'	=> 0.3937,
       'millimeter' => 0.03937
    },
# Synonyms and abbreviations for these units
    {
               'cm'	=> 'centimeter',
               'mm'	=> 'millimeter',
               'in'	=> 'inch',
               'pt'	=> 'point',
               'pc'	=> 'pica'
    },
# Mulipliers (so we can say "half-pica" or "sixteenths of an inch")
    {
             'half'	=> 1/2,
            'third'	=> 1/3,
          'quarter'	=> 1/4,
           'eighth'	=> 1/8,
           'twelth'	=> 1/12,
        'sixteenth'	=> 1/16
    },
# The default unit to convert to (when none is specified)
    "point"
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
