# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 1562 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/_FindMatchingChar.al)"
# find a matching char for the given one
sub _FindMatchingChar
{
	my ($w,$sc,$pos,$slimit,$elimit) = @_;
	my $mc = ${$w->{MATCHINGCOUPLES}->{$sc}}[0];	# char to search
	
	if(!defined $mc) {return undef;}
	
	my $dir = ${$w->{MATCHINGCOUPLES}->{$sc}}[1];	# forward or backward search
	my $spos=($dir == 1 ? $w->index("$pos + $dir c") : $w->index($pos));
	my $d=1;
	my ($p,$c);
	my $match;

	if($dir == 1) {	# forward search
		$match="[\\$mc|\\$sc]+";
		for($p=$spos;$w->compare($p,'<',$elimit);$p=$w->index("$p + 1c")) {
			$p=$w->SUPER::search('-forwards','-regex','--',$match,$p,$elimit);
			if(!defined $p) {return undef;}
			$c=$w->get($p);
			if($c eq $mc) {
				$d--;
				if($d == 0) {
					return $p;
				}
			} elsif($c eq $sc) {
				$d++;
			}
			Tk::DoOneEvent(Tk::DONT_WAIT);
		}
	} else {	# backward search
		$match="[\\$sc|\\$mc]+";
		for($p=$spos;$w->compare($p,'>=',$slimit);) {
			$p=$w->SUPER::search('-backwards','-regex','--',$match,$p,$slimit);
			if(!defined $p) {return undef;}
			$c=$w->get($p);
			if($c eq $mc) {
				$d--;
				if($d == 0) {
					return $p;
				}
			} elsif($c eq $sc) {
				$d++;
			}
			if($w->compare($p,'==','1.0')) {return undef;}
			Tk::DoOneEvent(Tk::DONT_WAIT);
		}
	}
	return undef;
}

# end of Tk::Text::SuperText::_FindMatchingChar
1;
