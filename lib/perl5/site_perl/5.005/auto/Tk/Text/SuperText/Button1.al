# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 474 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/Button1.al)"
# redefine Button1for parentheses highlight
sub Button1
{
	my $w = shift;
	my $str;
	
	$w->SUPER::Button1(@_);
	
	if((!defined $w->tag('ranges','sel')) && $w->cget('-showmatching') == 1) {
		if(exists %{$w->{MATCHINGCOUPLES}}->{$str=$w->get('insert','insert + 1c')}) {
			# calculate visible zone and search only in this one
			my ($l,$c) = split('\.',$w->index('end'));
			my ($slimit,$elimit) = $w->yview;
			
			$slimit=int($l*$slimit)+1;
			$slimit="$slimit.0";
			$elimit=int($l*$elimit);
			$elimit="$elimit.0";
			my $i=$w->_FindMatchingChar($str,'insert',$slimit,$elimit);
			if(defined $i) {
				my $sel = Tk::catch {$w->tag('nextrange','match','1.0','end');};
				if(defined $sel) {$w->tag('remove','match','match.first');}
				$w->tag('add','match',$i,$w->index("$i + 1c"));
				my $t=$w->cget('-matchhighlighttime');
				if($t != 0) {$w->after($t,[\&removeMatch,$w,$i]);}
			}
		}
	}
}	

# end of Tk::Text::SuperText::Button1
1;
