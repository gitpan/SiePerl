# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 687 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/_AddRedo.al)"
# add a new redo command to the redo stack
sub _AddRedo
{
	my ($w,$op,@args) = @_;
	my ($rsize,$rdepth);
	
	$w->{REDO} = [] unless(exists $w->{REDO});
	
	# check for undo depth limit
	$rsize = @{$w->{REDO}} + 1;
	$rdepth = $w->cget('-undodepth');
	
	if(defined $rdepth) {
		if($rdepth == 0) {return;}
		if($rsize >= $rdepth) {
			# free oldest undo sequence
			$rdepth=$rsize - $rdepth + 1;
			splice(@{$w->{REDO}},0,$rdepth);
		}
	}
	if($op =~ /^#_/) {push(@{$w->{REDO}},[$op]);}
	else {push(@{$w->{REDO}},['SUPER::'.$op,@args]);}
}

# end of Tk::Text::SuperText::_AddRedo
1;
