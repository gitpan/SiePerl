# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 564 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/resetUndo.al)"
# resets undo and redo buffers
sub resetUndo
{
	my $w = shift;
	
	delete $w->{UNDO};
	delete $w->{REDO};
}

# end of Tk::Text::SuperText::resetUndo
1;
