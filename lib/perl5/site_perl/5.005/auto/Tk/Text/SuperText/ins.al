# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 1383 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/ins.al)"
sub ins
{
	my $w = shift;

	$w->{LINESTART}=0;
	if($w->{INSERTMODE} eq 'insert') {$w->{INSERTMODE}='overwrite';}
	elsif($w->{INSERTMODE} eq 'overwrite') {$w->{INSERTMODE}='insert';}
}

# end of Tk::Text::SuperText::ins
1;
