# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 1479 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/deleteToWordStart.al)"
sub deleteToWordStart
{
	my $w = shift;
	
	if($w->compare('insert','==','insert wordstart')) {
		$w->delete('insert - 1c');
	} else {
		$w->delete('insert wordstart','insert');
	}
}

# end of Tk::Text::SuperText::deleteToWordStart
1;
