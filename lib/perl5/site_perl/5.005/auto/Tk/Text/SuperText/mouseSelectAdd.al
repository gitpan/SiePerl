# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 826 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/mouseSelectAdd.al)"
sub mouseSelectAdd
{
	my $w = shift;
	my $ev = $w->XEvent;

	$Tk::selectionType='normal';
	$w->ResetAnchor($ev->xy);	
	$w->SelectTo($ev->xy,'char');
}

# end of Tk::Text::SuperText::mouseSelectAdd
1;
