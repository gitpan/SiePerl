# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 1649 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/escape.al)"
sub escape
{
	my $w = shift;
	$w->tag('remove','sel','1.0','end');
}

# end of Tk::Text::SuperText::escape
1;
