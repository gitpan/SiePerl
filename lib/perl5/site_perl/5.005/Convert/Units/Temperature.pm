package Convert::Units::Temperature;
require 5.004;
require Exporter;

use vars qw($VERSION $self);
$VERSION = "0.21";

use Convert::Units::Base;

my $self = new Convert::Units::Base
  (
# The actual units, relative to each other (in this case, in inches)
    {
          'celsius' => [1.0,    0],
     'fahrenheight' => [5/9,  -32],
           'kelvin' => [1.0, -273]
    },
# Synonyms and abbreviations for these units
    {
       'centigrade' => 'celsius',
                'c' => 'celsius',
                'f' => 'fahrenheight',
                'k' => 'kelvin'
    },
# Mulipliers
    (),
# The default unit to convert to (when none is specified)
    "celsius"
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

