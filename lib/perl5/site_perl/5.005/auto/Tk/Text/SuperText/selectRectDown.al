# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 1112 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/selectRectDown.al)"
sub selectRectDown
{
	my $w = shift;

	$w->{LINESTART}=0;
	$Tk::selectionType='rect';
	$w->KeySelect($w->UpDownLine(1));
}

# end of Tk::Text::SuperText::selectRectDown
1;
