# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 900 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/mouseMovePage.al)"
sub mouseMovePage
{
	my $w = shift;
	my $ev = $w->XEvent;

	$w->Motion2($ev->x,$ev->y);
}

# end of Tk::Text::SuperText::mouseMovePage
1;
