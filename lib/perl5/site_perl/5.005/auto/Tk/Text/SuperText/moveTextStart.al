# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 1167 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/moveTextStart.al)"
sub moveTextStart
{
	my $w = shift;

	$w->{LINESTART}=0;
	$w->SetCursor('1.0');
}

# end of Tk::Text::SuperText::moveTextStart
1;
