# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 655 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/_AddUndo.al)"
# add an undo command to the undo stack
sub _AddUndo
{
	my ($w,$op,@args) = @_;
	my ($usize,$udepth);
	
	$w->{UNDO} = [] unless(exists $w->{UNDO});
	# check for undo depth limit
	$usize = @{$w->{UNDO}} + 1;
	$udepth = $w->cget('-undodepth');
	
	if(defined $udepth) {
		if($udepth == 0) {return;}
		if($usize >= $udepth) {
			# free oldest undo sequence
			$udepth=$usize - $udepth + 1;
			splice(@{$w->{UNDO}},0,$udepth);
		}
	}
	if($op =~ /^#_/) {push(@{$w->{UNDO}},[$op]);}
	else {push(@{$w->{UNDO}},['SUPER::'.$op,@args]);}
}

# end of Tk::Text::SuperText::_AddUndo
1;
