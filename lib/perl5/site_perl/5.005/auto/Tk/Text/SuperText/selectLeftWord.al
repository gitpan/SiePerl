# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 1000 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/selectLeftWord.al)"
sub selectLeftWord
{
	my $w = shift;

	$w->{LINESTART}=0;
	$Tk::selectionType='normal';
	$w->KeySelect($w->index("insert - 1c wordstart"));
}

# end of Tk::Text::SuperText::selectLeftWord
1;
