# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 549 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/_BeginUndoBlock.al)"
# Key binding Events subs

sub _BeginUndoBlock
{
	my $w = shift;

	$w->_AddUndo('#_BlockEnd_#');
}

# end of Tk::Text::SuperText::_BeginUndoBlock
1;
