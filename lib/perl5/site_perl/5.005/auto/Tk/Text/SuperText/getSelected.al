# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 410 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/getSelected.al)"
sub getSelected
{
	my $w = shift;
	
	if(!defined $Tk::selectionType || ($Tk::selectionType eq 'normal')) {
		return $w->SUPER::getSelected;
	} elsif ($Tk::selectionType eq 'rect') {
		my ($sl,$sc) = split('\.',$w->index('sel.first'));
		my ($el,$ec) = split('\.',$w->index('sel.last'));
		my ($i,$x);
		my ($sel,$str);
		
		$sel="";
		
		# walk throught all the selected lines and add a sel tag
		for($i=$sl;$i<=$el;$i++) {
			my ($l,$c) = split('\.',$w->index("$i.end"));
			# check if  selection is too much to the right
			if($sc > $c) {next;}
			# or clif if too wide
			if($ec <= $c) {$x=$ec;}
			else { $x=$c;}
			$str=$w->get($w->index("$i.$sc"),$w->index("$i.$x"));
			# add a new line if not the last line
			if(substr($str,-1,1) ne "\n") {
				$str=$str."\n";
			}
			$sel=$sel.$str;
		}
		return $sel;
	}
}

# end of Tk::Text::SuperText::getSelected
1;
