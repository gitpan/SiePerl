# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 1284 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/setSelectionMark.al)"
sub setSelectionMark
{
	my $w = shift;

	$w->{LINESTART}=0;
	$w->markSet('anchor','insert');
}

# end of Tk::Text::SuperText::setSelectionMark
1;