# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 854 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/mouseSelectAutoScan.al)"
sub mouseSelectAutoScan
{
	my $w = shift;
	my $ev = $w->XEvent;

	$Tk::selectionType='normal';
	$Tk::x=$ev->x;
	$Tk::y=$ev->y;
	$w->AutoScan;
}

# end of Tk::Text::SuperText::mouseSelectAutoScan
1;
