# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 1218 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/ScrollPages.al)"
sub ScrollPages
{
	my ($w,$count) = @_;
	my ($l,$c) = $w->index('end');
	my ($slimit,$elimit) = $w->yview;
	# get current page top and bottom line coords
	$slimit=int($l*$slimit)+1;
	$slimit="$slimit.0";
	$elimit=int($l*$elimit);
	$elimit="$elimit.0";
	# position insert cursor at text begin/end if the text is scrolled to begin/end
	if($count < 0 && $w->compare($slimit,'<=','1.0')) {return('1.0');}
	elsif($count >= 0 && $w->compare($elimit,'>=','end')) {return($w->index('end'));}
	else {return $w->SUPER::ScrollPages($count);}
}

# end of Tk::Text::SuperText::ScrollPages
1;
