# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 712 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/SelectTo.al)"
# manage mouse normal and rectangular selections  for char,word or line mode
# overrides standard Tk::Text->SelectTo method
sub SelectTo
{
	my $w = shift;
	my $index = shift;
	$Tk::selectMode = shift if (@_);
	my $cur = $w->index($index);
	my $anchor = Tk::catch{$w->index('anchor')};

	# check for mouse movement
	if(!defined $anchor) {
		$w->markSet('anchor',$anchor=$cur);
		$Tk::mouseMoved=0;
	} elsif($w->compare($cur,"!=",$anchor)) {
		$Tk::mouseMoved=1;
	}
	$Tk::selectMode='char' unless(defined $Tk::selectMode);

	my $mode = $Tk::selectMode;
 	my ($first,$last);

	# get new selection limits
	if($mode eq 'char') {
		if($w->compare($cur,"<",'anchor')) {
			$first=$cur;
			$last='anchor';
		} else {
			$first='anchor';
			$last=$cur;
		}
	} elsif($mode eq 'word') {
		if($w->compare($cur,"<",'anchor')) {
			$first = $w->index("$cur wordstart");
			$last = $w->index("anchor - 1c wordend");
		} else {
			$first=$w->index("anchor wordstart");
			$last=$w->index("$cur wordend");
		}
	} elsif($mode eq 'line') {
		if($w->compare($cur,"<",'anchor')) {
			$first=$w->index("$cur linestart");
			$last=$w->index("anchor - 1c lineend + 1c");
		} else {
			$first=$w->index("anchor linestart");
			$last=$w->index("$cur lineend + 1c");
		}
	}
	# update selection
	if($Tk::mouseMoved || $Tk::selectMode ne 'char') {
		if((!defined $Tk::selectionType) || ($Tk::selectionType eq 'normal')) {
			# simple normal selection
			$w->tag('remove','sel','1.0',$first);
			$w->tag('add','sel',$first,$last);
			$w->tag('remove','sel',$last,'end');
			$w->idletasks;
		} elsif($Tk::selectionType eq 'rect') {
			my ($sl,$sc) = split('\.',$w->index($first));
			my ($el,$ec) = split('\.',$w->index($last));
			my $i;
			
			# swap min,max x,y coords
			if($sl >= $el) {($sl,$el)=($el,$sl);}
			if($sc >= $ec) {($sc,$ec)=($ec,$sc);}

			$w->tag('remove','sel','1.0','end');
			# add a selection tag to all the selected lines
			# FIXME: the selection's right limit is the line lenght of the line where mouse is on.BAD!!! 
			for($i=$sl;$i<=$el;$i++) {
				$w->tag('add','sel',"$i.$sc","$i.$ec");
			}
			$w->idletasks;
		}
	} 
}

# end of Tk::Text::SuperText::SelectTo
1;
