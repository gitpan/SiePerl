# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 966 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/moveLeft.al)"
sub moveLeft
{
	my $w = shift;

	$w->{LINESTART}=0;
	$w->SetCursor($w->index("insert - 1c"));
}

# end of Tk::Text::SuperText::moveLeft
1;
