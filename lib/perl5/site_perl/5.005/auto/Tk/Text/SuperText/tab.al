# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 1655 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/tab.al)"
sub tab
{
	my $w = shift;

	$w->Insert("\t");
	$w->focus;
	$w->break;
}

# end of Tk::Text::SuperText::tab
1;
