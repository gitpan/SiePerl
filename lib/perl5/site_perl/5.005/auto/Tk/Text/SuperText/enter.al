# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 1392 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/enter.al)"
sub enter
{
	my $w = shift;

	$w->_BeginUndoBlock;
	Tk::catch {$w->Insert("\n")};
	if($w->cget('-indentmode') eq 'auto') {
		$w->_AutoIndent;
	}
	$w->_EndUndoBlock;
}

# end of Tk::Text::SuperText::enter
1;
