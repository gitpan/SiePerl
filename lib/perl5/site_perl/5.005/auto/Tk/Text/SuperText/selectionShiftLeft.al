# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 1310 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/selectionShiftLeft.al)"
sub selectionShiftLeft
{
	my $w = shift;
	
	$w->{LINESTART}=0;
	$w->_SelectionShift(" ","left");
}

# end of Tk::Text::SuperText::selectionShiftLeft
1;
