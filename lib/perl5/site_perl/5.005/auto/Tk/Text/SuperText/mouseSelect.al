# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 795 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/mouseSelect.al)"
sub mouseSelect
{
	my $w = shift;
	my $ev = $w->XEvent;

	$Tk::selectionType='normal';
	$Tk::x=$ev->x;
	$Tk::y=$ev->y;
	$w->SelectTo($ev->xy);
}

# end of Tk::Text::SuperText::mouseSelect
1;
