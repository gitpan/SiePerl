# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 1318 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/selectionShiftLeftTab.al)"
sub selectionShiftLeftTab
{
	my $w = shift;
	
	$w->{LINESTART}=0;
	$w->_SelectionShift("\t","left");
}

# end of Tk::Text::SuperText::selectionShiftLeftTab
1;
