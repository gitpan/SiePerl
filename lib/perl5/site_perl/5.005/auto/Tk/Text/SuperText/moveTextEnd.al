# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 1201 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/moveTextEnd.al)"
sub moveTextEnd
{
	my $w = shift;

	$w->{LINESTART}=0;
	$w->SetCursor('end - 1c');
}

# end of Tk::Text::SuperText::moveTextEnd
1;
