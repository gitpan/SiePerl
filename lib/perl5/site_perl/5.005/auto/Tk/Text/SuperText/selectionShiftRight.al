# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 1326 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/selectionShiftRight.al)"
sub selectionShiftRight
{
	my $w = shift;
	
	$w->{LINESTART}=0;
	$w->_SelectionShift(" ","right");
}

# end of Tk::Text::SuperText::selectionShiftRight
1;
