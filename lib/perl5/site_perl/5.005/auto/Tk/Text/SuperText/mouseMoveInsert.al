# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 872 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/mouseMoveInsert.al)"
sub mouseMoveInsert
{
	my $w = shift;
	my $ev = $w->XEvent;

	$Tk::selectionType='normal';
	$w->markSet('insert',$ev->xy);
}

# end of Tk::Text::SuperText::mouseMoveInsert
1;
