# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 1342 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/_SelectionShift.al)"
sub _SelectionShift
{
	my ($w,$type,$dir) = @_;
	
	if((!defined $type) || (!defined $dir)) {return;}
	if(!defined $w->tag('ranges','sel')) {return;}
	
	my ($sline,$scol) = split('\.',$w->index('sel.first'));
	my ($eline,$ecol) = split('\.',$w->index('sel.last'));
	
	my $col;
	if($Tk::selectionType eq 'rect') {$col=$scol;}
	else {$col=0;}
	
	if($ecol == 0) {$eline--;}
	
	my $s;
	$w->_BeginUndoBlock;
	if($dir eq "left") {
		if($scol != 0) {$scol--;}
		$w->delete("$sline.$scol");
		for(my $i=$sline+1;$i <= $eline;$i++) {
			$s="$i.$scol";
			if($w->compare($s,'==',$w->index("$s lineend"))) {next;}
			$w->delete("$i.$scol");
			$w->idletasks;
		}
	} elsif($dir eq "right") {
		$w->insert("$sline.$scol",$type);
		for(my $i=$sline+1;$i <= $eline;$i++) {
#			$w->insert("$i.$scol",$type);
			$s="$i.$scol";
			$w->markSet('undopos' => $s);
			$w->SUPER::insert($s,$type);
			$w->_AddUndo('delete',$s,$w->index('undopos'));
			$w->idletasks;
		}
	}
	$w->_EndUndoBlock;
}

# end of Tk::Text::SuperText::_SelectionShift
1;
