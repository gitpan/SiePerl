# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 1539 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/insertControlCode.al)"
sub insertControlCode
{
	my $w = shift;
	
	$w->{LINESTART}=0;
	$w->{ASCIICODE} = 1;
}

# end of Tk::Text::SuperText::insertControlCode
1;
