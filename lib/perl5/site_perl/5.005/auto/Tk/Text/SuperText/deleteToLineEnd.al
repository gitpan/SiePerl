# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 1513 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/deleteToLineEnd.al)"
sub deleteToLineEnd
{
	my $w = shift;
	
	if($w->compare('insert','==','insert lineend')) {
		$w->delete('insert');
	} else {
		$w->delete('insert','insert lineend');
	}
}

# end of Tk::Text::SuperText::deleteToLineEnd
1;
