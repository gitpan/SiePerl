# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 1251 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/movePageLeft.al)"
sub movePageLeft
{
	my $w = shift;

	$w->{LINESTART}=0;
	$w->xview('scroll',-1,'page');
}

# end of Tk::Text::SuperText::movePageLeft
1;
