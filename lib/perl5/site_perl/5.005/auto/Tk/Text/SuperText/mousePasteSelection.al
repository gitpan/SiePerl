# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 908 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/mousePasteSelection.al)"
sub mousePasteSelection
{
	my $w = shift;
	my $ev = $w->XEvent;

	if(!$Tk::mouseMoved) {
		Tk::catch { $w->insert($ev->xy,$w->SelectionGet);};
	}
}

# end of Tk::Text::SuperText::mousePasteSelection
1;
