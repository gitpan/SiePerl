# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 383 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/deleteSelected.al)"
# clipboard methods that must be overriden for rectangular selections

sub deleteSelected
{
	my $w = shift;
	
	if(!defined $Tk::selectionType || ($Tk::selectionType eq 'normal')) {
		$w->SUPER::deleteSelected;
	} elsif ($Tk::selectionType eq 'rect') {
		my ($sl,$sc) = split('\.',$w->index('sel.first'));
		my ($el,$ec) = split('\.',$w->index('sel.last'));
		my ($i,$x);
		
		# delete only text in the rectangular selection range
		$w->_BeginUndoBlock;
		for($i=$sl;$i<=$el;$i++) {
			my ($l,$c) = split('\.',$w->index("$i.end"));
			# check if selection is too right (??) for this line
			if($sc > $c) {next;}
			# and clip selection
			if($ec <= $c) {$x=$ec;}
			else { $x=$c;}
			
			$w->delete($w->index("$i.$sc"),$w->index("$i.$x"));
		}
		$w->_EndUndoBlock;
	}
}

# end of Tk::Text::SuperText::deleteSelected
1;
