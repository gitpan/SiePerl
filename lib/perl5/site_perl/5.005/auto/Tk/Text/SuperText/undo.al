# NOTE: Derived from blib/lib/Tk/Text/SuperText.pm.
# Changes made here will be lost when autosplit again.
# See AutoSplit.pm.
package Tk::Text::SuperText;

#line 573 "blib/lib/Tk/Text/SuperText.pm (autosplit into blib/lib/auto/Tk/Text/SuperText/undo.al)"
# undo last operation
sub undo
{
	my ($w) = @_;
	my $s;
	my $op;
	my @args;
	my $block = 0;
	
	if(exists $w->{UNDO}) {
		if(@{$w->{UNDO}}) {
			# undo loop
			while(1) {
				# retrive undo command
				my ($op,@args) = Tk::catch{@{pop(@{$w->{UNDO}})};};

				if($op eq '#_BlockBegin_#') {
					$w->_AddRedo('#_BlockEnd_#');
					$block=1;
					next;
				} elsif($op eq '#_BlockEnd_#') {
					$w->_AddRedo('#_BlockBegin_#');
					return 1;
				}
				# convert for redo
				if($op =~ /insert$/) {
					# get current insert position
					$s = $w->index($args[0]);
					# mark for getting the with of the insertion
					$w->markSet('redopos' => $s);
				} elsif ($op =~ /delete$/) {
					# save text and position
					my $str = $w->get(@args);
					$s = $w->index($args[0]);
					
					$w->_AddRedo('insert',$s,$str);
				}
				# execute undo command
				$w->$op(@args);
				$w->SetCursor($args[0]);
				# insert redo command
				if($op =~ /insert$/) {
					$w->_AddRedo('delete',$s,$w->index('redopos'));
				}
				if($block == 0) {return 1;}
			}
		}
	}
	$w->bell;
	return 0;
}

# end of Tk::Text::SuperText::undo
1;
