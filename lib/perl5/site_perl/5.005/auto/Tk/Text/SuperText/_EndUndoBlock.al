# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 556 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/_EndUndoBlock.al)"
sub _EndUndoBlock
{
	my $w = shift;

	$w->_AddUndo('#_BlockBegin_#');
}

# end of Tk::Text::SuperText::_EndUndoBlock
1;
