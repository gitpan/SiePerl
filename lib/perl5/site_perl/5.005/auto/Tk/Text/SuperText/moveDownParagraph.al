# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 1121 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/moveDownParagraph.al)"
sub moveDownParagraph
{
	my $w = shift;

	$w->{LINESTART}=0;
	$w->SetCursor($w->NextPara('insert'));
}

# end of Tk::Text::SuperText::moveDownParagraph
1;
