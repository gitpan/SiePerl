# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 1242 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/selectToPageUp.al)"
sub selectToPageUp
{
	my $w = shift;

	$w->{LINESTART}=0;
	$Tk::selectionType='normal';
	$w->KeySelect($w->ScrollPages(-1));
}

# end of Tk::Text::SuperText::selectToPageUp
1;
