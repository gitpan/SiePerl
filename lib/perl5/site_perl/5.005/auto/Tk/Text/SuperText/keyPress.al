# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 1724 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/keyPress.al)"
sub keyPress
{
	my $w = shift;
	my $ev = $w->XEvent;

	$w->Insert($ev->A);
}

# end of Tk::Text::SuperText::keyPress
1;
