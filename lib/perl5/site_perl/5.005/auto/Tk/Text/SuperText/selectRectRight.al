# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 1026 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/selectRectRight.al)"
sub selectRectRight
{
	my $w = shift;

	$w->{LINESTART}=0;
	$Tk::selectionType='rect';
	$w->KeySelect($w->index("insert + 1c"));
}

# end of Tk::Text::SuperText::selectRectRight
1;
