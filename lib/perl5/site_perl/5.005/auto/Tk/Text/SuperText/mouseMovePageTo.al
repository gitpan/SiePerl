# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 892 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/mouseMovePageTo.al)"
sub mouseMovePageTo
{
	my $w = shift;
	my $ev = $w->XEvent;

	$w->Button2($ev->x,$ev->y);
}

# end of Tk::Text::SuperText::mouseMovePageTo
1;
