# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 1192 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/selectToLineEnd.al)"
sub selectToLineEnd
{
	my $w = shift;

	$w->{LINESTART}=0;
	$Tk::selectionType='normal';
	$w->KeySelect('insert lineend');
}

# end of Tk::Text::SuperText::selectToLineEnd
1;
