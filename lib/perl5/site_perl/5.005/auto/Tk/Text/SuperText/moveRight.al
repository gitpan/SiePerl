# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 1009 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/moveRight.al)"
sub moveRight
{
	my $w = shift;

	$w->{LINESTART}=0;
	$w->SetCursor($w->index("insert + 1c"));
}

# end of Tk::Text::SuperText::moveRight
1;
