# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 918 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/KeySelect.al)"
sub KeySelect
{
	my $w = shift;
	my $new = shift;
	my ($first,$last);
	if(!defined $w->tag('ranges','sel')) {
		# No selection yet
		$w->markSet('anchor','insert');
		if($w->compare($new,"<",'insert')) {
			$w->tag('add','sel',$new,'insert');
		} else {
			$w->tag('add','sel','insert',$new);
		}
	} else {
		# Selection exists
		if($w->compare($new,"<",'anchor')) {
			$first=$new;
			$last='anchor';
		} else {
			$first='anchor';
			$last=$new;
		}
		if((!defined $Tk::selectionType) || ($Tk::selectionType eq 'normal')) {
			$w->tag('remove','sel','1.0',$first);
			$w->tag('add','sel',$first,$last);
			$w->tag('remove','sel',$last,'end');
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
		}
	}
	$w->markSet('insert',$new);
	$w->see('insert');
	$w->idletasks;
}

# end of Tk::Text::SuperText::KeySelect
1;
