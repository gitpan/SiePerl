# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 1683 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/paste.al)"
sub paste
{
	my $w = shift;

	Tk::catch{$w->clipboardPaste;};
	$w->see('insert');
}

# end of Tk::Text::SuperText::paste
1;
