# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 1501 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/deleteToLineStart.al)"
sub deleteToLineStart
{
	my $w = shift;

	if($w->compare('insert','==','1.0')) {return;}
	if($w->compare('insert','==','insert linestart')) {
		$w->delete('insert - 1c');
	} else {
		$w->delete('insert linestart','insert');
	}
}

# end of Tk::Text::SuperText::deleteToLineStart
1;
