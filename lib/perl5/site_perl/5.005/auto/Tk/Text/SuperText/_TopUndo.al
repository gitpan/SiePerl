# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 678 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/_TopUndo.al)"
# return the last added undo command
sub _TopUndo
{
	my ($w) = @_;
	
	return undef unless (exists $w->{UNDO});
	return $w->{UNDO}[-1];
}

# end of Tk::Text::SuperText::_TopUndo
1;
