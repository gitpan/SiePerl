# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 625 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/redo.al)"
# redo last undone operation
sub redo
{
	my ($w) = @_;
	my $block = 0;
	
	if(exists $w->{REDO}) {
		if(@{$w->{REDO}}) {
			while(1) {
				my ($op,@args) = Tk::catch{@{pop(@{$w->{REDO}})};};

				if($op eq '#_BlockBegin_#') {
					$w->_AddUndo('#_BlockEnd_#');
					$block=1;
					next;
				} elsif($op eq '#_BlockEnd_#') {
					$w->_AddUndo('#_BlockBegin_#');
					return 1;
				}
				$op =~ s/^SUPER:://;
				$w->$op(@args);
				$w->SetCursor($args[0]);
				if($block == 0) {return 1;}
			}
		}
	}
	$w->bell;
	return 0;
}

# end of Tk::Text::SuperText::redo
1;
