# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 1675 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/cut.al)"
sub cut
{
	my $w = shift;

	Tk::catch{$w->clipboardCut;};
	$w->see('insert');
}

# end of Tk::Text::SuperText::cut
1;
