# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 1531 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/deleteLine.al)"
sub deleteLine
{
	my $w = shift;

	$w->delete('insert linestart','insert lineend + 1c');
	$w->markSet('insert','insert linestart');
}

# end of Tk::Text::SuperText::deleteLine
1;
