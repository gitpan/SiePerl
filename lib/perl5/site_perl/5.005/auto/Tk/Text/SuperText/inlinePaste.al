# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 1691 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/inlinePaste.al)"
sub inlinePaste
{
	my $w = shift;
	my ($l,$c) = split('\.',$w->index('insert'));
	my $str;
	my $f=0;
	Tk::catch{$str=$w->clipboardGet;};
	
	if($str eq "") {return;}
	$w->_BeginUndoBlock;
	while($str =~ /(.*)\n+/g) {
		$w->insert("$l.$c",$1);
		if($f == 0) {
			my ($el,$ec) = split('\.',$w->index('end'));
			if($l == $el) {
				$w->insert('end',"\n");
				$f=1;
			}
		} else {$w->insert('end',"\n");}
		$l++;
		$w->idletasks;
	}
	$w->_EndUndoBlock;
	$w->see('insert');
}

# end of Tk::Text::SuperText::inlinePaste
1;
