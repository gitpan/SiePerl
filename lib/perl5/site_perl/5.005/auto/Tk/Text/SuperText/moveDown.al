# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 1095 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/moveDown.al)"
sub moveDown
{
	my $w = shift;

	$w->{LINESTART}=0;
	$w->SetCursor($w->UpDownLine(1));
}

# end of Tk::Text::SuperText::moveDown
1;
