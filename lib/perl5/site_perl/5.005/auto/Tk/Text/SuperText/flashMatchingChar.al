# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 1612 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/flashMatchingChar.al)"
sub flashMatchingChar
{
	my $w = shift;
	my $s = $w->index('insert');
	my $str = $w->get('insert');
	
	if(exists %{$w->{MATCHINGCOUPLES}}->{$str}) {
		my $i=$w->_FindMatchingChar($str,$s,"1.0","end");
		if(defined $i) {
			my $sel = Tk::catch {$w->tag('nextrange','match','1.0','end');};
			if(defined $sel) {$w->tag('remove','match','match.first');}
			$w->tag('add','match',$i,$w->index("$i + 1c"));
			my $t=$w->cget('-matchhighlighttime');
			if($t != 0) {$w->after($t,[\&removeMatch,$w,$i]);}
			return $i;
		}
	}
	return undef;
}

# end of Tk::Text::SuperText::flashMatchingChar
1;
