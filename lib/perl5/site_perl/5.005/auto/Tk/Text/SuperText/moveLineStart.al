# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 1138 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/moveLineStart.al)"
sub moveLineStart
{
	my $w = shift;
	
	if(exists $w->{LINESTART} && $w->{LINESTART} == 1) {
		$w->SetCursor('insert linestart');
		$w->{LINESTART}=0;
	} else {
		$w->{LINESTART}=1;
		my $str = $w->get('insert linestart','insert lineend');
		my $i=0;
	
		if($str =~ /^(\s+)(\S*)/) {
			if($2) {$i=length($1);}
			else {$i=0};
		}
		$w->SetCursor("insert linestart + $i c");
	}
}

# end of Tk::Text::SuperText::moveLineStart
1;
