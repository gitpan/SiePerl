# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 1421 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/_AutoIndent.al)"
sub _AutoIndent
{
	my $w = shift;
	my ($line,$col) = split('\.',$w->index('insert'));

	# no autoindent for first line
	if($line == 1) {return;}
	$line--;
	my $s=$w->get("$line.0","$line.end");
	if($s =~ /^(\s+)(\S*)/) {$s=$1;}
	else {$s='';}
	if($2) {
		$w->insert('insert linestart',$s);
	}
}

# end of Tk::Text::SuperText::_AutoIndent
1;
