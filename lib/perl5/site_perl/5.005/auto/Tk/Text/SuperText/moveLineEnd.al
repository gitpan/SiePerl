# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 1184 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/moveLineEnd.al)"
sub moveLineEnd
{
	my $w = shift;

	$w->{LINESTART}=0;
	$w->SetCursor('insert lineend');
}

# end of Tk::Text::SuperText::moveLineEnd
1;
