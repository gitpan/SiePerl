# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 983 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/selectRectLeft.al)"
sub selectRectLeft
{
	my $w = shift;

	$w->{LINESTART}=0;
	$Tk::selectionType='rect';
	$w->KeySelect($w->index("insert - 1c"));
}

# end of Tk::Text::SuperText::selectRectLeft
1;
