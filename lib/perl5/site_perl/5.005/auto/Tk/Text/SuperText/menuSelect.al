# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 1732 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/menuSelect.al)"
sub menuSelect
{
	my $w = shift;
	my $ev = $w->XEvent;

	$w->TraverseToMenu($ev->K);
}

# end of Tk::Text::SuperText::menuSelect
1;
