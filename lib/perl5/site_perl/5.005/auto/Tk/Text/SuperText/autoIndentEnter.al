# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 1404 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/autoIndentEnter.al)"
sub autoIndentEnter
{
	my $w = shift;

	$w->_BeginUndoBlock;
	Tk::catch {$w->Insert("\n")};
	$w->_AutoIndent;
	$w->_EndUndoBlock;
}

# end of Tk::Text::SuperText::autoIndentEnter
1;
