# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 786 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/mouseSetInsert.al)"
sub mouseSetInsert
{	
	my $w = shift;
	my $ev = $w->XEvent;

	$w->{LINESTART}=0;
	$w->Button1($ev->x,$ev->y);
}

# end of Tk::Text::SuperText::mouseSetInsert
1;
