# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 1668 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/copy.al)"
sub copy
{
	my $w = shift;

	Tk::catch{$w->clipboardCopy;};
}

# end of Tk::Text::SuperText::copy
1;
