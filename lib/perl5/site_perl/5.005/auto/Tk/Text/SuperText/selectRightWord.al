# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 1043 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/selectRightWord.al)"
sub selectRightWord
{
	my $w = shift;

	$w->{LINESTART}=0;
	$Tk::selectionType='normal';
	$w->KeySelect($w->index("insert wordend"));
}

# end of Tk::Text::SuperText::selectRightWord
1;
