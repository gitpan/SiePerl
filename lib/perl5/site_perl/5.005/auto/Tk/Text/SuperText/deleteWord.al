# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 1524 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/deleteWord.al)"
sub deleteWord
{
	my $w = shift;

	$w->delete('insert wordstart','insert wordend');
}

# end of Tk::Text::SuperText::deleteWord
1;
