# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 806 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/mouseSelectWord.al)"
sub mouseSelectWord
{
	my $w = shift;
	my $ev = $w->XEvent;

	$Tk::selectionType='normal';
	$w->SelectTo($ev->xy,'word');
	Tk::catch {$w->markSet('insert',"sel.first")};
}

# end of Tk::Text::SuperText::mouseSelectWord
1;
