# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 836 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/mouseSelectAddWord.al)"
sub mouseSelectAddWord
{
	my $w = shift;
	my $ev = $w->XEvent;

	$Tk::selectionType='normal';
	$w->SelectTo($ev->xy,'word');
}

# end of Tk::Text::SuperText::mouseSelectAddWord
1;
