# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 1078 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/moveUpParagraph.al)"
sub moveUpParagraph
{
	my $w = shift;

	$w->{LINESTART}=0;
	$w->SetCursor($w->PrevPara('insert'));
}

# end of Tk::Text::SuperText::moveUpParagraph
1;
