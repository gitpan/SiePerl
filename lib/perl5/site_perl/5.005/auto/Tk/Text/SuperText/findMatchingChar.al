# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 1632 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/findMatchingChar.al)"
sub findMatchingChar
{
	my $w = shift;
	my $i = $w->flashMatchingChar;
	
	if(defined $i) {$w->see($i);}
}

# end of Tk::Text::SuperText::findMatchingChar
1;
