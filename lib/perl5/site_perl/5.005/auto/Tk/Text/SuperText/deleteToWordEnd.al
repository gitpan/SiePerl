# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 1490 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/deleteToWordEnd.al)"
sub deleteToWordEnd
{
	my $w = shift;
	
	if($w->compare('insert','==','insert wordend')) {
		$w->delete('insert');
	} else {
		$w->delete('insert','insert wordend');
	}
}

# end of Tk::Text::SuperText::deleteToWordEnd
1;
