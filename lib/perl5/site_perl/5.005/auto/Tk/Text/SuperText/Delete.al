# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 1445 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/Delete.al)"
# overrides Tk::Text->Delete method
sub Delete
{
	my $w = shift;
	my $sel = Tk::catch {$w->tag('nextrange','sel','1.0','end');};
	
	if(defined $sel) {
		$w->deleteSelected;
	} else {
		$w->delete('insert');
		$w->see('insert');
	}
}

# end of Tk::Text::SuperText::Delete
1;
