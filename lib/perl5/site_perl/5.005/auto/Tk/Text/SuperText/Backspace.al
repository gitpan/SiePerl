# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 1466 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/Backspace.al)"
# overrides Tk::Text->Backspace method
sub Backspace
{
	my $w = shift;
	my $sel = Tk::catch {$w->tag('nextrange','sel','1.0','end');};
	
	if(defined $sel) {
		$w->deleteSelected;
	} elsif($w->compare('insert',"!=",'1.0')) {
		$w->delete('insert - 1c');
		$w->see('insert');
	}	
}

# end of Tk::Text::SuperText::Backspace
1;
